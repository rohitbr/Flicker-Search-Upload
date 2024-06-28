//
//  LoginView.swift
//  FlickerSearch
//
//  Created by Bhat, Rohit on 6/5/24.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

struct LoginView: View {
    var goToRegistration: () -> ()
    var loginSuccessScreen: () -> ()
    
    @EnvironmentObject var vm: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Background
            BackgroundGradient()
            
            // Content
            VStack {
                LogoView()
                    .padding()
                TextField("Username", text: $vm.userName)
                    .withCustomInputTextFieldModifier()
                SecureField("Password", text: $vm.password)
                    .withCustomInputTextFieldModifier()
                Button {
                    Task {
                        let result = await vm.signInWithEmailAndPassword()
                        if result == true {
                            loginSuccessScreen()
                        }
                    }
                } label: {
                    ButtonWithProgress(title: "Sign in")
                }
                
                DescriptionText(title: "OR")
                
                Button {
                    signInWithGoogle()
                } label: {
                    ButtonView(title: "Sign into google", imageName: "GoogleLogo")
                }
                
                
                SignInWithAppleButton { request in
                    vm.handleSigninRequest(request)
                } onCompletion: { result in
                    vm.handleSigninResult(result)
                }
                .frame(height: 50)
                .cornerRadius(20)
                .padding(.horizontal)
                
                
                HStack(spacing: nil) {
                    DescriptionText(title: "Don't have an account click here")
                    FrontArrowImage()
                }
                .onTapGesture {
                    goToRegistration()
                }
            }
        }
    }
    
    
    private func signInWithGoogle() {
        Task {
            if await vm.signInWithGoogle() == true {
                dismiss()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView {
            print("Register")
        } loginSuccessScreen: {
            print("Login Success")
        }
        
    }
}
