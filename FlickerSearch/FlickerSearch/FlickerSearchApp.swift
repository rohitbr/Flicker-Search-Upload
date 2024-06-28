//
//  FlickerSearchApp.swift
//  FlickerSearch
//
//  Created by Bhat, Rohit on 5/27/24.
//

import SwiftUI
import FirebaseCore
import OAuthSwift

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,  didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    //    func applicationHandle(url: URL) {
    //        if (url.host == "oauth-callback") {
    //            OAuthSwift.handle(url: url)
    //        } else {
    //            // Google provider is the only one with your.bundle.id url schema.
    //            OAuthSwift.handle(url: url)
    //        }
    //    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("Open url app delegate function called")
        print("url host is \(url.host)")
        if url.host == "oauth-callback" {
            OAuthSwift.handle(url: url)
        }
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        //        applicationHandle(url: url)
        print("Open url app delegate function called")
        
        return true
    }
    
    //    @available(iOS 9.0, *)
    //    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    //        applicationHandle(url: url)
    //        return true
    //    }
}


@main
struct FlickerSearchApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            AuthenticationMainView()
                .environmentObject(AuthenticationViewModel())
                .onOpenURL { (url) in
                    if url.host == "oauth-callback" {
                        OAuthSwift.handle(url: url)
                    }                     // Handle url here
                }
        }
    }
}

