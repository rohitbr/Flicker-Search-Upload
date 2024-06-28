//
//  UploadPictureViewModel.swift
//  FlickerSearch
//
//  Created by Bhat, Rohit on 6/21/24.
//

import SwiftUI
import OAuthSwift

class UploadPictureViewModel: ObservableObject {
    @Published var openCameraSheet: Bool = false
    @Published var pickedImage: UIImage?
    @AppStorage("oauth_token") private var oauthToken = ""
    @AppStorage("auth_token_secret") private var oauthTokenSecret = ""
    let serviceParameters: [String:String] = ["consumerKey": Constants.kApiKey, "consumerSecret": Constants.kSecret]
    @Published var showSpinner = false
    var postImageFailed : Bool?
    
    var oauthswift : OAuth1Swift?
    func doService() {
        doOAuthFlickr()
    }
    
    func getURLHandler() -> OAuthSwiftURLHandlerType {
        if #available(iOS 13.0, *) {
            return OAuthSwiftOpenURLExternally.sharedInstance
        }
    }
    
    func postImage() {
        guard let img = pickedImage?.jpegData(compressionQuality: 0.0) else {
            print ("cant convert image")
            return
        }
        
        let multiparts = [ OAuthSwiftMultipartData(name: "photo", data: img, fileName: "file", mimeType: "image/jpeg") ]
        showSpinner = true
        
        oauthswift!.client.postMultiPartRequest("https://up.flickr.com/services/upload/", method: .POST, parameters: serviceParameters, multiparts: multiparts) { [weak self] result in
            switch result {
            case .success(_):
                print("Success")
                self?.postImageFailed = false
            case .failure(_):
                print("failure")
                self?.postImageFailed = true
                self?.doOAuthFlickr()
            }
            self?.showSpinner = false
        }
    }
    
    // MARK: Flickr
    func doOAuthFlickr(){
        oauthswift = OAuth1Swift(
            consumerKey:    serviceParameters["consumerKey"]!,
            consumerSecret: serviceParameters["consumerSecret"]!,
            requestTokenUrl: "https://www.flickr.com/services/oauth/request_token",
            authorizeUrl:    "https://www.flickr.com/services/oauth/authorize",
            accessTokenUrl:  "https://www.flickr.com/services/oauth/access_token"
        )
        
        if (!oauthToken.isEmpty && !oauthTokenSecret.isEmpty && !(postImageFailed ?? false)) {
            postImage()
        } else {
            let _ = oauthswift?.authorize(
                withCallbackURL: URL(string: "flicker-search://oauth-callback/flickr")!) { [weak self] result in
                    switch result {
                    case .success(let (credential, _, _)):
                        if !credential.oauthTokenSecret.isEmpty && !credential.oauthToken.isEmpty {
                            self?.oauthToken = credential.oauthToken
                            self?.oauthTokenSecret = credential.oauthTokenSecret
                        }
                        
                        self?.postImage()
                    case .failure(let error):
                        print("Coming here in error")
                        print(error.description)
                    }
                }
        }
    }
}
