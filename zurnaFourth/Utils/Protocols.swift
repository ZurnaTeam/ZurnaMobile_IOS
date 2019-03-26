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

//struct Post: Codable {
//   
//    var id: String?
//    var content: Content?
//    var comments: [Comment]?
//    var userid: String?
//
//}
//struct Content: Codable {
//    var text: String?
//    var image: String?
//    var hashtag: String?
//    var location: Location?
//    var time: String?
//    var like: Int?
//    var dislike: Int?
//    var view: Int?
//}
//struct Location: Codable {
//    var lat: String?
//    var lon: String?
//    var country: String?
//    var city: String?
//}
//struct Comment: Codable {
//    var text: String?
//    var time: String?
//    var userid: String?
//}


//static let basePath = "http://77.223.142.42/plesk-site-preview/azorlua.com/api/posts"
//
//static func forecast (completion: @escaping ([Post]) -> ()){
//
//    let url = basePath
//    let request = URLRequest(url: URL(string: url)!)
//
//    let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
//
//        var forecastArray: [Post] = []
//        if let data = data {
//            do{
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
//                    if let posts = try? Post(json: json){
//                        //                            print(json["id"])
//                        //                            print(json["content"])
//                        //                            print(json["comments"])
//                        //                            print(json["userid"])
//                        print("merhaba")
//                        forecastArray.append(posts)
//                    }
//                    print("merhaba")
//                }
//            }catch{
//                print(error.localizedDescription)
//            }
//            completion(forecastArray)
//        }
//
//    }
//    task.resume()
//
//
//}
