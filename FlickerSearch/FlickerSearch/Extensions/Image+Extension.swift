//
//  Image+Extension.swift
//  FlickerSearch
//
//  Created by Bhat, Rohit on 6/21/24.
//

import Foundation
import SwiftUI

extension Image {
    func systemImageViewModifier() -> some View {
        self
            .resizable()
            .frame(width: 150, height: 150)
            .foregroundColor(.accentColor)
            .padding(16)
            .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.accentColor, lineWidth: 8.0))
            .padding(16)
            .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.accentColor, lineWidth: 8.0))
    }
    
    func profileImageModifier() -> some View {
        self
            .resizable()
            .frame(width: 120, height: 120)
//            .clipShape(Circle())
    }
}
