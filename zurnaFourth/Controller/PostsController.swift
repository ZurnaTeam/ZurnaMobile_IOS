//
//  PostsController.swift
//  zurnaFourth
//
//  Created by Yavuz on 13.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

import UIKit
import CoreLocation

class PostsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate, commentControllerProtocol {
    
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
        var view = MenuController().view
        MenuController().viewDidLoad()
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
    
    override func viewDidLoad() {
        setupCollectionViewLayout()
        setupCollectionView()
        setupHashMenu()
        
        let hashMenuOpen = UISwipeGestureRecognizer(target: self, action: #selector(toggleMenuBar(sender:)))
        let hashMenuClose = UISwipeGestureRecognizer(target: self, action: #selector(toggleMenuBar(sender:)))
        hashMenuClose.direction = .left
       
        hashImage.addGestureRecognizer(hashMenuOpen)
        hashImage.addGestureRecognizer(hashMenuClose)

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
        hashMenuBarConstrait = NSLayoutConstraint(item: menuControllerView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: -155)//SıkıntılıLayout
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
    //MARK Hashtagler gelecek
    //MARK Postlar gelecek
    //MARK Commentler gelecek
    //MARK Internet var mi kontrolu yapilacak
    //MARK Comment kisminda az comment varken klavye ciktigi vakit bug oluyor
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
        collectionView.backgroundColor = .yellow
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
        return 18
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostsViewCell
        
        cell.backgroundColor = .black
        cell.frame.origin.x = indexPath.row % 2 == 0 ?  0 : self.view.frame.width - cell.frame.width
        cell.postTextField.text = "deneme"
        cell.postTextField.textColor = .white

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 2 * padding, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            navigationController?.pushViewController(CommentController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segu:CommentController = segue.destination as? CommentController {
            segu.delegate = self
        }
    }
    
    func getPost() -> String {
        return "deneme"
    }
}
