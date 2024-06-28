//
//  RegistrationView.swift
//  FlickerSearch
//
//  Created by Bhat, Rohit on 6/5/24.
//

import SwiftUI

struct RegistrationView: View {
    var registrationSuccessScreen: () -> ()
    var goToLogin: () -> ()
    @EnvironmentObject var vm: AuthenticationViewModel
    
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
                
                SecureField("Re-Password", text: $vm.confirmPassword)
                    .withCustomInputTextFieldModifier()

                    
                    Button {
                        Task {
                            let result = await vm.signUpWithEmailAndPassword()
                            if result == true {
                                registrationSuccessScreen()
                            } 
                        }
                    } label: {
                        ButtonWithProgress(title: "Register now")
                    }
                    .padding(.vertical)
                    .disabled(!vm.signUpEntryValid)
                
                HStack {
                    DescriptionText(title: "Already have an account, click here")
                    FrontArrowImage()
                }
                .onTapGesture {
                    goToLogin()
                }
               
            }
        }
        
    }
}

struct ButtonWithProgress: View {
    @EnvironmentObject var vm: AuthenticationViewModel
    let title: String
    var body: some View {
        VStack {
            if vm.userAuthenticationState != .userSigningIn {
                ButtonView(title: title)
            }
            else {
                ProgressView()
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(registrationSuccessScreen: {
            print("Successful registration")
        }, goToLogin: {
            print("Got to login")
        })
        .environmentObject(AuthenticationViewModel())
    }
}
