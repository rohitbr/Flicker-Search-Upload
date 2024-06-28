//
//  FrontArrowImage.swift
//  FlickerSearch
//
//  Created by Bhat, Rohit on 6/18/24.
//

import SwiftUI

struct FrontArrowImage: View {
    var body: some View {
        Image(systemName: "arrowshape.turn.up.right.fill")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(.accentColor)
    }
}

struct FrontArrowImage_Previews: PreviewProvider {
    static var previews: some View {
        FrontArrowImage()
    }
}
