//
//  MenuController.swift
//  zurnaFourth
//
//  Created by Yavuz on 15.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

import UIKit
private let reuseIdentifer = "MenuOptionCell"

class MenuController: UITableViewController{
    //
    //MARK: - Properties
//    var tableView: UITableView!
    var hashtags: [String]? = [String]()
    var hashtagsIds: [String]? = [String]()
    var selected: [Int:Bool]? = [Int:Bool]()
    var selectedIndex: [Int]? = [Int]()
    var selectedRowBool: [Bool]? = [Bool]()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        getHashtagsFromAPI()
        
    }
    
    
    //MARK: - Handlers
    fileprivate func configureTableView(){
//        tableView = UITableView()
//        tableView.delegate = self
//        tableView.dataSource = self

        tableView.register(MenuOptionCell.self, forCellReuseIdentifier: reuseIdentifer )
        tableView.backgroundColor = UIColor(red:0.94, green:0.78, blue:0.76, alpha:1.0)
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
//        
//        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
    }
    fileprivate func getHashtagsFromAPI() {
        HashTag.getHashTag { (results:[String]) in
            DispatchQueue.main.async {
                for result in results{
                    if !results.isEmpty{
                        self.hashtags?.append(result)
//                        self.postsIds?.append(result.id!)
                    }
                }
                 self.tableView.reloadData()
            }
           
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = hashtags?.count{
            return count
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! MenuOptionCell

        //        let menuOption = MenuOption(rawValue: indexPath.row)
        
        if let hashtag = hashtags?[indexPath.item]{
            cell.descriptionLabel.text = hashtag
            selectedIndex?.append(indexPath.item)
            selectedRowBool?.append(false)
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(hashtags?[indexPath.item])
        
        if let hashtag = hashtags?[indexPath.item]{
//            let postController = PostsController(collectionViewLayout: UICollectionViewFlowLayout())
//            postController.getPostsFromAPIForHashtag(hashtag: hashtag)
            
            
            if let index = selectedIndex?[indexPath.item]{
                if !selectedRowBool![index]{
                    print(index)
                    selectedRowBool![index] = true
                    
                    var dic: Dictionary<String, String> = Dictionary()
                    dic.updateValue(hashtag as String, forKey: "hashtag")
                    NotificationCenter.default.post(name: Notification.Name("didSelectHashtag"), object: nil, userInfo: dic)
                    
                    if let cell = self.tableView.cellForRow(at: indexPath){
                        
                        cell.accessoryType = .checkmark
                    }
                }
                else{
                    selectedRowBool![index] = false
                    NotificationCenter.default.post(name: Notification.Name("didClearHashtag"), object: nil, userInfo: nil)
                    if let cell = self.tableView.cellForRow(at: indexPath){
                        cell.accessoryType = .none
                    }
                }
                
            }
            
            
        }
        
        
    }
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) {
//            cell.accessoryType = .none
//        }
//    }
    
}
//extension MenuController: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 4
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! MenuOptionCell
//
////        let menuOption = MenuOption(rawValue: indexPath.row)
//        cell.descriptionLabel.text = "menuOption?.description"
//
//        return cell
//    }
////    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//////        let menuOption = MenuOption(rawValue: indexPath.row)
//////        delegate?.handleMenuToggle(forMenuOption: menuOption)
////    }
//}

