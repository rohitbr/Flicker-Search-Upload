//
//  MainTabbedView.swift
//  FlickerSearch
//
//  Created by Bhat, Rohit on 6/21/24.
//

import SwiftUI

struct MainTabbedView: View {
    
    var body: some View {
        TabView {
            FlickerSearchListView()
                .tabItem {
                    Label("Flicker Search", systemImage: "heart.circle")
                }
            
            UploadPictureView()
                .tabItem {
                    Label("Upload Picture", systemImage: "square.and.arrow.up.circle.fill")
                }
        }
    }
}

struct MainTabbedView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabbedView()
    }
}
