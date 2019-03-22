//
//  Protocols.swift
//  zurnaFourth
//
//  Created by Yavuz on 18.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

protocol PostControllerDelegate {
    func getPost(post: String)
}

struct Post: Codable {
    var id: String?
    var content: Content?
    var comments: [Comment]?
    var userid: String?
}
struct Content: Codable {
    var text: String?
    var image: String?
    var hashtag: String?
    var location: Location?
    var time: String?
    var like: Int?
    var dislike: Int?
    var view: Int?
}
struct Location: Codable {
    var lat: String?
    var lon: String?
    var country: String?
    var city: String?
}
struct Comment: Codable {
    var text: String?
    var time: String?
    var userid: String?
}


