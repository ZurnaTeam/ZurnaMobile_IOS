//
//  PostStruct.swift
//  zurnaFourth
//
//  Created by Yavuz on 25.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

import Foundation
import UIKit

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
    //Get Post
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
    //Send Post
    static func postStruct(text: String, lat: String, lon: String, country: String, city: String){
        
        let id = NSUUID().uuidString
        let url = "http://77.223.142.42/plesk-site-preview/azorlua.com/api/posts/"
        let date = Date()
        let postUserId = UserDefaults.standard.string(forKey: "userId")
        // prepare json data
//        let comments: Comment = Comment.init()
        let location: Location = Location.init(lat: lat, lon: lon, country: country, city: city)
        let content = Content.init(text: text, image: nil, hashtag: "#local", location: location, time: "\(date)", like: 0, dislike: 0, view: 0)
        let json: Post = Post.init(id: "\(id)", content: content, comments: nil, userid: postUserId)

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
    //Get Comment
    static func commentDownloadNPost (text:String, id: String, comment: Bool, rate: Bool, view: Bool){
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
            if view{
                //Increase view
                Post.updateViewPost(post: post, id: id)
            }
            
            else if comment{
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
    //Send Comment
    static func commentPost(post: Post,text: String,id: String){
        
        let commentUserid = UserDefaults.standard.string(forKey: "userId")
        let url = "http://77.223.142.42/plesk-site-preview/azorlua.com/api/posts/\(id)"
        let date = Date()
        // prepare json data
        let comment: Comment = Comment.init(text: text, time: "\(date)", userid: commentUserid)
        var comments: [Comment] = [Comment].init()
        if let comment = post.comments{
            comments = comment
        }
        comments.append(comment)
        var content: Content = Content.init()
        if let _content = post.content{
            content = _content
        }
        let postUserId = post.userid
        let json: Post = Post.init(id: "\(id)", content: content, comments: comments, userid: postUserId)
        
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
        
        
        let url = "http://77.223.142.42/plesk-site-preview/azorlua.com/api/posts/\(id)"
        // prepare json data
        
        var comments: [Comment] = [Comment].init()
        var content: Content = Content.init()
        // prepare json data
        if let comment = post.comments{
            comments = comment
        }
        if let _content = post.content{
            content = _content
            if like{
                content.like = content.like! + 1
            }
            else{
                content.dislike = content.dislike! + 1
            }
        }

        let postUserId = post.userid
        let json: Post = Post.init(id: "\(id)", content: content, comments: comments, userid: postUserId)
        
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
    //Increase View
    static func updateViewPost(post: Post,id: String){
        
        let url = "http://77.223.142.42/plesk-site-preview/azorlua.com/api/posts/\(id)"
        var comments: [Comment] = [Comment].init()
        var content: Content = Content.init()
        // prepare json data
        if let comment = post.comments{
            comments = comment
        }
        if let _content = post.content{
            content = _content
            content.view = content.view! + 1
        }
        
        let postUserId = post.userid
        let json: Post = Post.init(id: "\(id)", content: content, comments: comments, userid: postUserId)
        
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
    
    //User Register
    static func userRegister(userid: String,device: String){
        var lat = ""
        var lon = ""
        var city = ""
        var country = ""
        if let _lat = UserDefaults.standard.string(forKey: "lat"){
            lat = _lat
        }
        if let _lon = UserDefaults.standard.string(forKey: "lon"){
            lon = _lon
        }
        if let _city = UserDefaults.standard.string(forKey: "city"){
            city = _city
        }
        if let _country = UserDefaults.standard.string(forKey: "country"){
            country = _country
        }
        let id = userid
        let url = "http://77.223.142.42/plesk-site-preview/azorlua.com/api/users"
        let date = Date()
        // prepare json data

        
        let location: Location = Location.init(lat: lat, lon: lon, country: country, city: city)
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
    //Get User
    static func getUser (id: String){
        
        let lastActivity = Date()
        let url = "http://77.223.142.42/plesk-site-preview/azorlua.com/api/users/\(id)"
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
            guard let user = try? JSONDecoder().decode(Users.self, from: data) else {
                print("Error: Couldn't decode data into post")
                return
            }
            if let _ = user.id{
                updateUserLastActivity(user: user, id: id,lastActivity: lastActivity)
            }
            else{
                let userid = UserDefaults.standard.string(forKey: "userId")
                let deviceId = UIDevice.current.identifierForVendor?.uuidString
                
                Users.userRegister(userid: userid!,device: deviceId!)
                UserDefaults.standard.set(true, forKey: "didYouRegister")
                UserDefaults.standard.set(userid, forKey: "userId")
            }
            
        }
        task.resume()
        task.suspend()
    }
    //Update User Last Activity
    static func updateUserLastActivity(user: Users,id: String,lastActivity: Date){
        
        let url = "http://77.223.142.42/plesk-site-preview/azorlua.com/api/users/\(id)"
    
        // prepare json data
        var user: Users = user
        user.lastactivitydate = "\(lastActivity)"
        
        let json: Users = user
        
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


