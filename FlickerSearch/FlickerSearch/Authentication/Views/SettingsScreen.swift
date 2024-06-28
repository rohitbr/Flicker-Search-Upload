//
//  SettingsScreen.swift
//  FlickerSearch
//
//  Created by Bhat, Rohit on 6/8/24.
//

import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject var vm: AuthenticationViewModel
    
    var body: some View {
        ZStack {
            BackgroundGradient()
            
            VStack {
                Image(systemName: "person.circle.fill")
                    .systemImageViewModifier()
                    .padding(.bottom)
                
                DescriptionText(title: "User is \(vm.user?.email ?? "")")
                
                Button {
                    vm.signOut()
                } label: {
                    ButtonView(title: "Log out")
                }
                Spacer()
            }
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
