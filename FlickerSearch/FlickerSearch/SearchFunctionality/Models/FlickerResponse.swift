//
//  FlickerResponse.swift
//  FlickerSearch
//
//  Created by Bhat, Rohit on 5/27/24.
//

import Foundation

//
//"photos": {
//    "page": 1,
//    "pages": 1230,
//    "perpage": 100,
//    "total": 122926,
//    "photo": [
//      {
//        "id": "53751272149",
//        "owner": "30476193@N00",
//        "secret": "9fe773041d",
//        "server": "65535",
//        "farm": 66,
//        "title": "IMG_1881.jpg",
//        "ispublic": 1,
//        "isfriend": 0,
//        "isfamily": 0
//      },
//      {
//        "id": "53750878416",
//        "owner": "167129605@N05",
//        "secret": "38668776d0",
//        "server": "65535",
//        "farm": 66,
//        "title": "DSCN7109",
//        "ispublic": 1,
//        "isfriend": 0,
//        "isfamily": 0
//      },

struct Photo: Decodable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
    
    var photoUrl : URL? {
        let photoBaseUrl = "https://live.staticflickr.com/"
        let urlString = photoBaseUrl + server + "/" + id + "_" + secret + "_w.jpg"
        return URL(string: urlString) ?? nil
    }

}

struct Photos: Decodable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int64
    let photo : [Photo]
}

struct FlickerResponse : Decodable {
    let photos : Photos
}
