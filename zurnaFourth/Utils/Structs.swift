//
//  PostStruct.swift
//  zurnaFourth
//
//  Created by Yavuz on 25.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

import Foundation

//MARK: - Post Struct
struct Post: Codable {

    var id: String?
    var content: Content?
    var comments: [Comment]?
    var userid: String?
    
    enum CodingKeys: String, CodingKey{
        case id
        case content
        case comments
        case userid
    }
    //Post
    static func downloadStruct (completion: @escaping ([Post]) -> ()){
        let url = "http://77.223.142.42/plesk-site-preview/azorlua.com/api/posts"
        let request = URLRequest(url: URL(string: url)!)
    
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            
            guard let posts = try? JSONDecoder().decode([Post].self, from: data) else {
                print("Error: Couldn't decode data into post")
                return
            }
            completion(posts)
        }
        task.resume()
        task.suspend()
    }
    static func postStruct(text: String){
        
        let id = NSUUID().uuidString
        let url = "http://77.223.142.42/plesk-site-preview/azorlua.com/api/posts/"
        let date = Date()
        // prepare json data
//        let comments: Comment = Comment.init()
        let location: Location = Location.init(lat: "23.021", lon: "31.12", country: "Turkey", city: "Elazig")
        let content = Content.init(text: text, image: nil, hashtag: "#local", location: location, time: "\(date)", like: 10, dislike: 10, view: 10)
        let json: Post = Post.init(id: "\(id)", content: content, comments: nil, userid: "Yavuz")

        guard let jsonData = try? JSONEncoder().encode(json) else {
            return
        }
        
        // create post request
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.uploadTask(with: request, from: jsonData, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            print(data)
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
            
        })
        task.resume()
        task.suspend()
    }
    //Comment
    static func commentDownloadNPost (text:String, id: String, comment: Bool, rate: Bool){
        let url = "http://77.223.142.42/plesk-site-preview/azorlua.com/api/posts/\(id)"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            guard let post = try? JSONDecoder().decode(Post.self, from: data) else {
                print("Error: Couldn't decode data into post")
                return
            }
            if comment{
                //Send Comment
                Post.commentPost(post: post, text: text, id: id)
            }
            else{
                //Rate Post
                Post.ratePost(post: post, like: rate, id: id)
            }
            
        }
        task.resume()
        task.suspend()
    }
    static func commentPost(post: Post,text: String,id: String){
        //MARK Userid ler duzeltilecek
        //MARK Lokasyon alinacak
        
        let url = "http://77.223.142.42/plesk-site-preview/azorlua.com/api/posts/\(id)"
        let date = Date()
        // prepare json data
        let comment: Comment = Comment.init(text: text, time: "\(date)", userid: "yavuz")
        var comments: [Comment] = post.comments!
        comments.append(comment)
        let content: Content = post.content!
        let json: Post = Post.init(id: "\(id)", content: content, comments: comments, userid: "Yavuz")
        
        guard let jsonData = try? JSONEncoder().encode(json) else {
            return
        }
        
        // create post request
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.uploadTask(with: request, from: jsonData, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            print(data)
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }    
        })
        task.resume()
        task.suspend()
    }
    //Up-Down Rate
    static func ratePost(post: Post,like: Bool,id: String){
        //MARK Userid ler duzeltilecek
        //MARK Lokasyon alinacak
        
        let url = "http://77.223.142.42/plesk-site-preview/azorlua.com/api/posts/\(id)"
        // prepare json data
        let comments: [Comment] = post.comments!
        var content: Content = post.content!
        if like{
            content.like = content.like! + 1
        }
        else{
            content.dislike = content.dislike! + 1
        }
        
        let json: Post = Post.init(id: "\(id)", content: content, comments: comments, userid: "Yavuz")
        
        guard let jsonData = try? JSONEncoder().encode(json) else {
            return
        }
        
        // create post request
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.uploadTask(with: request, from: jsonData, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            print(data)
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        })
        task.resume()
        task.suspend()
    }
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

//MARK: - User Struct
struct Users: Codable {
    var id: String?
    var location: Location?
    var registerdate: String?
    var deviceid: String?
    var lastactivitydate: String?
    var isbanned: Bool?
    var phone: String?
    
    static func userRegister(device: String){
        let id = NSUUID().uuidString
        let url = "http://77.223.142.42/plesk-site-preview/azorlua.com/api/users"
        let date = Date()
        // prepare json data
        
        //MARK lokasyon girilsin
        //MARK Lastactivity guncellensin
        let location: Location = Location.init(lat: "23.021", lon: "31.12", country: "Turkey", city: "Elazig")
        let json: Users = Users.init(id: "\(id)", location: location, registerdate: "\(date)", deviceid: "\(device)", lastactivitydate: "\(date)", isbanned: false, phone: nil)
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//        json.data(using: String.Encoding.utf8)
        guard let jsonData = try? JSONEncoder().encode(json) else {
            return
        }
        // create post request
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.uploadTask(with: request, from: jsonData, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            print(data)
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
            
        })
        task.resume()
        task.suspend()
    }
}

