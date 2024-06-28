//
//  DescriptionText.swift
//  FlickerSearch
//
//  Created by Bhat, Rohit on 6/6/24.
//

import SwiftUI

struct DescriptionText: View {
    var title: String = ""
    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.medium)
            .italic()
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.1)
    }
}

struct DescriptionText_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionText(title : "This is a very long text")
    }
}
