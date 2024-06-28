//
//  DefaultSearchView.swift
//  FlickerSearch
//
//  Created by Bhat, Rohit on 6/21/24.
//

import SwiftUI

struct DefaultSearchView: View {
    @Binding var searchTerm: String
    let popularKeyWords = ["Cat", "Dog", "Bus", "Car", "Aeroplane"]
    var body: some View {
        VStack {
            Text("Popular Words")
                .font(.title2)
            ForEach(0..<popularKeyWords.count) { keyWord in
                Button(popularKeyWords[keyWord]) {
                    searchTerm = popularKeyWords[keyWord]
                }
                .padding()
            }
        }
    }
}

struct DefaultSearchView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultSearchView(searchTerm: .constant("Cat"))
    }
}
