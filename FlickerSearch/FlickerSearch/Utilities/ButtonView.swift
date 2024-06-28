//
//  ButtonView.swift
//  FlickerSearch
//
//  Created by Bhat, Rohit on 6/5/24.
//

import SwiftUI

struct ButtonView: View {
    
    var title: String = ""
    var imageName: String = ""
    var hasHorizontalPadding: Bool = true
    var body: some View {
        HStack {
                if !imageName.isEmpty {
                    Image(imageName)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 20)
                        .background(Color.white
                            .cornerRadius(10)
                        )
                        
                }
            
            Text(title)
               
        }
        .font(.title3)
        .fontWeight(.medium)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            Rectangle()
                .fill(Color.accentColor)
        )
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(hasHorizontalPadding ? .horizontal : [])
    }
}


struct ButtonViewGenericView <T: View> : View {
    let content : T
    
    init(@ViewBuilder content: () -> T) {
        self.content = content()
    }
    
    var body: some View {
        content
            .font(.headline)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .background(
                Rectangle()
                    .fill(Color.accentColor)
            )
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding(.horizontal)
            .frame(height: 20)

    }
}


struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView()
    }
}
