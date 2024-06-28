//
//  AuthenticationMainView.swift
//  FlickerSearch
//
//  Created by Bhat, Rohit on 6/5/24.
//

import SwiftUI

@available(iOS 13.0, *)
struct AuthenticationMainView: View {
    
    @EnvironmentObject var vm: AuthenticationViewModel
    
    var body: some View {
        ZStack {
            switch vm.userAuthenticationState {
            case .userSignedOut:
                WelcomeView {
                    vm.userAuthenticationState = .login
                }
            case .login:
                LoginView {
                    vm.userAuthenticationState = .register
                } loginSuccessScreen: {
                    vm.userAuthenticationState = .userSignedIn
                }
            case .register:
                RegistrationView {
                    vm.userAuthenticationState = .userSignedIn
                } goToLogin: {
                    vm.userAuthenticationState = .login
                }
            case .userSignedIn:
                MainTabbedView()
            case .userSigningIn:
                EmptyView()
            }
        }
        .alert(isPresented: $vm.showFailureAlert) {
            Alert(title: Text("Something went wrong"), message: Text("\(vm.errorMessage)"))
        }
    }
}

struct AuthenticationMainView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationMainView()
    }
}
