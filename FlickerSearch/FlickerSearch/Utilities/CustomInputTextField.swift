//
//  CustomInputTextField.swift
//  FlickerSearch
//
//  Created by Bhat, Rohit on 6/12/24.
//

import SwiftUI

struct CustomInputTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.gray.opacity(0.4).cornerRadius(20))
            .font(.headline)
            .foregroundColor(.accentColor)
            .padding(.horizontal)
    }
}

extension View {
    func withCustomInputTextFieldModifier() -> some View {
        modifier(CustomInputTextField())
    }
}
