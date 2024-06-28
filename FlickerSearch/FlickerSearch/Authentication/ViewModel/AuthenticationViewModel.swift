//
//  AuthenticationViewModel.swift
//  FlickerSearch
//
//  Created by Bhat, Rohit on 6/6/24.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import Combine

// For Sign in with Apple
import AuthenticationServices
import CryptoKit

enum AuthenticationState {
    case userSignedIn
    case userSigningIn
    case userSignedOut
    case login
    case register
}


@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var userAuthenticationState : AuthenticationState = .userSigningIn
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    @Published var user : User?
    private var subscriptions = Set<AnyCancellable>()
    @Published var signUpEntryValid = false
    @Published var signInEntryValid = false
    
    @Published var userIsValid = false
    @Published var errorMessage = ""
    @Published var showFailureAlert: Bool = false
    private var currentNonce: String?
    
    init() {
        registerAuthStateHandler()
        
        signUpEntryValidPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.signUpEntryValid, on: self)
            .store(in: &subscriptions)
        
        signInEntryValidPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.signInEntryValid, on: self)
            .store(in: &subscriptions)
    }
    
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener({ [weak self] auth, user in
                self?.user = user
                self?.userAuthenticationState = self?.user == nil ? .userSignedOut : .userSignedIn
            })
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out")
        }
    }
}

// MARK: Combine validators
extension AuthenticationViewModel {
    private var signUpEntryValidPublisher: AnyPublisher<Bool, Never> {
        Publishers
            .CombineLatest3($userName, $password, $confirmPassword)
            .map { (userName, password, confirmPassword) -> Bool in
                return userName.contains("@") &&
                password.count > 7 &&
                password == confirmPassword
            }.eraseToAnyPublisher()
    }
    
    private var signInEntryValidPublisher: AnyPublisher<Bool, Never> {
        Publishers
            .CombineLatest($userName, $password)
            .map { (userName, password) -> Bool in
                return userName.contains("@") &&
                password.count > 7
            }.eraseToAnyPublisher()
    }
}

// MARK: Signing related functions
extension AuthenticationViewModel {
    func signUpWithEmailAndPassword() async -> Bool {
        userAuthenticationState = .userSigningIn
        do {
            try await Auth.auth().createUser(withEmail: userName, password: password)
            return true
        } catch {
            userAuthenticationState = .register
            errorMessage = error.localizedDescription
            showFailureAlert.toggle()
            print("Sign up error \(error)")
            return false
        }
    }
    
    func signInWithEmailAndPassword() async -> Bool {
        userAuthenticationState = .userSigningIn
        do {
            try await Auth.auth().signIn(withEmail: userName, password: password)
            return true
        } catch {
            userAuthenticationState = .login
            errorMessage = error.localizedDescription
            showFailureAlert.toggle()
            print("Sign up error \(error)")
            return false
        }
    }
}

enum AuthenticationError: Error {
    case tokenError(message: String)
}

//MARK: Google sign in
extension AuthenticationViewModel {
    func signInWithGoogle() async -> Bool {
        guard let clientId = FirebaseApp.app()?.options.clientID else {
            fatalError("No client Id found")
        }
        
        let config = GIDConfiguration(clientID: clientId)
        
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController
        else {
            print("No Root View controller found")
            return false
        }
        
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            let user = userAuthentication.user
            
            // Get Id token and access token.
            guard let idToken = user.idToken else {
                throw AuthenticationError.tokenError(message: "ID token missing")
            }
            
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            let result = try await Auth.auth().signIn(with: credential)
            
            let firebaseUser = result.user
            
            print("Firebase user \(firebaseUser.uid), signed in with \(firebaseUser.email ?? "unknown")")
            return true
            
        } catch {
            print(error.localizedDescription)
            errorMessage = error.localizedDescription
            return false
        }
    }
}

//MARK: Apple sign in
extension AuthenticationViewModel {
    func handleSigninRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    func handleSigninResult(_ result: Result<ASAuthorization, Error> ) {
        switch result {
        case .failure(let error):
            errorMessage = error.localizedDescription
        case .success(let authorization):
            if let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: a login callback was requested but no request was sent")
                }
                guard let appleIdToken = appleIdCredential.identityToken else {
                    print("Apple id token not found")
                    return
                }
                
                guard let idStringToken = String(data: appleIdToken, encoding: .utf8) else {
                    print("cannot serialize id token")
                    return
                }
                
                let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idStringToken, rawNonce: nonce)
                
                Task {
                    do {
                        try await Auth.auth().signIn(with: credential)
                    }
                    catch {
                        print("Error authenticating: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
}
