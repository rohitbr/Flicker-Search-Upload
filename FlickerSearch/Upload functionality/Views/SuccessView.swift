//
//  SuccessView.swift
//  FruitCart
//
//  Created by Bhat, Rohit on 5/24/24.
//

import SwiftUI

struct HUDConfig {
    let text: String
    let icon: Image
    
    static func success(_ s: String) -> HUDConfig {
        return HUDConfig(text: s, icon: Image(systemName: "checkmark.circle.fill"))
    }
}

struct SuccessView: View {
    @State var showText = false
    @State var showIcon = false
    
    var config: HUDConfig
    var complete: () -> Void
    
    var body: some View {
        Group {
            ZStack {
                Text(config.text)
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .padding()
                    .opacity(showText ? 1 : 0)
                
                config.icon
                    .foregroundColor(Color.white)
                    .font(.title)
                    .padding()
                    .offset(x: showText ? 90 : 0, y: 0)
                    .opacity(showText ? 0 : 1)
            }
        }
        .background(
            Circle()
                .foregroundColor(Color.accentColor.opacity(0.7))
                .frame(width: 150, height: 150))
        .scaleEffect(showIcon ? 1 : 0)
        .onAppear {
            //transition, icon pops in
            withAnimation(Animation.easeOut) {
                showIcon = true
            }
            //after some delay text appears and icon rolling disappears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation(Animation.easeInOut) {
                    showText = true
                }
                // Send completion handler after the morph animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    complete()
                }
            }
        }
    }
}

