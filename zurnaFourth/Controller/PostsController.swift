//
//  PostsController.swift
//  zurnaFourth
//
//  Created by Yavuz on 13.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

import UIKit
import CoreLocation

public var sendedPost = "Sample Text"
public var sendedIndexPath: Int = -1

class PostsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
    
    //Structures
    
    
    //Properties

    var posts: [String]? = [String]()
    
    fileprivate let cellId = "cellId"
    fileprivate let headerId = "headerId"
    fileprivate let padding: CGFloat = 16
    
    var mark = ""
    var locationManager = CLLocationManager()
    var requestLocation = CLLocation()
    var hashImageConstraitY: NSLayoutConstraint?
    var hashImageConstraitX: NSLayoutConstraint?
    var hashMenuBarConstrait: NSLayoutConstraint?
    var menuControllerView : UIView = {
//        var view1 = UIView()
        var view = MenuController().view
//        MenuController().viewDidLoad()
        return view!
    }()
    
    let hashImage: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "home")
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout:layout)
        let model = UIDevice.current.identifierForVendor?.uuidString
        print("Device ID: \(model!)")
        setupLocation()
//        print(locationManager.location.)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func getPostsFromAPI() {
        let urlPost = URL(string: "http://77.223.142.42/plesk-site-preview/azorlua.com/api/posts")
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlPost!) { (data, response, error) in
            
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error.debugDescription, preferredStyle: UIAlertController.Style.alert)
                let okBtn = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okBtn)
                self.present(alert, animated: true, completion: nil)
            }else{
                if data != nil{
                    do{

                        let jsonResult = try JSONDecoder().decode([Post].self, from: data!)
                        DispatchQueue.main.async {
                            //print(jsonResult)
                            for i in 0..<jsonResult.count{
                                self.posts?.append((jsonResult[i].content?.text)!)
                            }
                            self.collectionView.reloadData()
                        }
                    }catch{
                        
                    }
                    
                }
            }
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        setupCollectionViewLayout()
        setupCollectionView()
        setupHashMenu()
        
        let hashMenuOpen = UISwipeGestureRecognizer(target: self, action: #selector(toggleMenuBar(sender:)))
        let hashMenuClose = UISwipeGestureRecognizer(target: self, action: #selector(toggleMenuBar(sender:)))
        hashMenuClose.direction = .left
       
        hashImage.addGestureRecognizer(hashMenuOpen)
        hashImage.addGestureRecognizer(hashMenuClose)
        
        getPostsFromAPI()
    }
    
    @objc func toggleMenuBar(sender: UISwipeGestureRecognizer){
        
        if sender.state == .ended {
            switch sender.direction{
            case .right:
                openMenu()
                print("opened menu")
            case .left:
                closeMenu()
                print("closed menu")
            default:
                break
            }
        }
    }
    fileprivate func setupHashMenu(){
        view.addSubview(hashImage)
        view.addConstraintsWithFormat(format: "H:|[v0(40)]", views: hashImage)
        view.addConstraintsWithFormat(format: "V:[v0(40)]", views: hashImage)
        hashImageConstraitY = NSLayoutConstraint(item: hashImage, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        hashImageConstraitX = NSLayoutConstraint(item: hashImage, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        view.addConstraint(hashImageConstraitY!)
        view.addConstraint(hashImageConstraitX!)
        
        view.addSubview(menuControllerView)
        menuControllerView.layer.shadowOpacity = 1
        menuControllerView.layer.shadowRadius = 5
        view.addConstraintsWithFormat(format: "H:|[v0(150)]", views: menuControllerView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: menuControllerView)
        hashMenuBarConstrait = NSLayoutConstraint(item: menuControllerView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: -155)//SıkıntılıLayout constanti 0 yapmak lazim ancak o zamanda ekranda surekli kaliyor
        view.addConstraint(hashMenuBarConstrait!)

        
    }
    fileprivate func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        requestLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
            if let placemark = placemarks{
                if placemark.count > 0 {
                    //print(location)
                    //print(placemark[0].administrativeArea)
                    //self.postTxt.text = placemark[0].administrativeArea
                    self.mark = (placemark[0].administrativeArea)!
                    print("Location icinde \(self.mark)")
                    //print("-----------")
                    //print(placemark[0].isoCountryCode)
                }
            }
        }
    }
    //Gonderenin adi yazilacak
    //Gonder butonu calisacak
    //Up-Down butonu calisacak
    //Yorum gonder butonu calisacak
    //Post kismindaki klavye kapatilacak
    //MARK Hashtagler gelecek
    //MARK Internet var mi kontrolu yapilacak
    //MARK Setting eklenebilir
    //MARK 1.Filtreleme olacak
    //MARK 1.1 Gezgin filtresi olacak secilen sehrin postlari gelecek
    //MARK 1.2 Hashtag filtresi olacak secilen hashtag postlari gelecek
    
//    MARK Hata olmayan uyarilar giderilecek
    func openMenu(){
        self.hashMenuBarConstrait?.constant = 0
        self.hashImageConstraitX?.constant = 150
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    func closeMenu(){
        self.hashMenuBarConstrait?.constant = -155
        self.hashImageConstraitX?.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    fileprivate func setupCollectionViewLayout() {
        //layout customization
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout{
            
            layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
        }
    }
    
    fileprivate func setupCollectionView() {
//        collectionView.backgroundColor = UIColor(red:0.94, green:0.78, blue:0.76, alpha:1.0)
//        collectionView.backgroundColor = UIColor(red:1.00, green:0.90, blue:0.83, alpha:1.0)
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .always
        
        collectionView.register(PostsViewCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 70)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = posts?.count{
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostsViewCell
        
//        cell.backgroundColor = .black
        cell.frame.origin.x = indexPath.row % 2 == 0 ?  0 : 2 * 16
        if let postContent = posts?[indexPath.item]{
            cell.postTextView.text = postContent
//            cell.postTextField.textColor = .white
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: postContent).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            cell.postTextView.frame = CGRect(x: 8, y: 0, width: cell.frame.width, height: estimatedFrame.height + 20)
            
            cell.textBubbleView.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: estimatedFrame.height + 20)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let messageText = posts?[indexPath.item]{
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            return CGSize(width: view.frame.width - 2 * padding , height: estimatedFrame.height + 20)
            
        }
        
        return CGSize(width: view.frame.width - 2 * padding, height: 50)
        
//        return .init(width: view.frame.width - 2 * padding, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PostsViewCell
        self.view.endEditing(true)
        
        sendedPost = cell.postTextView.text!
        sendedIndexPath = indexPath.item
        
        navigationController?.pushViewController(CommentController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
    }
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
