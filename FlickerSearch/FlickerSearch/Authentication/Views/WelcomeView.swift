//
//  WelcomeView.swift
//  FlickerSearch
//
//  Created by Bhat, Rohit on 6/5/24.
//

import SwiftUI

struct WelcomeView: View {
    var result: () -> ()
    var body: some View {
        ZStack {
            BackgroundGradient()
            
            VStack {
                Spacer()

                LogoView()
                    .padding()
                
                DescriptionText(title: "Welcome to Flicker search app")
                
                Button {
                    result()
                } label: {
                    ButtonView(title: "Tap here to Login")
                }
                
                Spacer()
                Spacer()
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView {
            print("Result")
        }
    }
}
