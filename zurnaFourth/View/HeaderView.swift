//
//  HeaderView.swift
//  zurnaFourth
//
//  Created by Yavuz on 13.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

import UIKit
import CoreLocation

class HeaderView: UICollectionReusableView, CLLocationManagerDelegate, UITextViewDelegate  {
    
    var mark = ""
    var locationManager = CLLocationManager()
    var requestLocation = CLLocation()
    var lat = String()
    var lon = String()
    var country = ""
    var city = ""
    
    let postTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.text = "Gönderi yazın."
        textView.returnKeyType = .done
        textView.textColor = UIColor.lightGray
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.cornerRadius = 15
        textView.layer.masksToBounds = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = true

        return textView
    }()

    
    let sendButton: UIButton = {
        let button = UIButton()
        
//        button.backgroundColor = UIColor(red:0.94, green:0.78, blue:0.76, alpha:1.0)
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "gonderBtn"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupLocation()
//        backgroundColor = UIColor(red:0.94, green:0.78, blue:0.76, alpha:1.0)
        backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        addSubview(postTextView)
        addSubview(sendButton)
        postTextView.delegate = self
        
        let centerY = frame.height/4
        
        addConstraintsWithFormat(format: "H:|[v0][v1(50)]-1-|", views: postTextView, sendButton)
        addConstraintsWithFormat(format: "V:|[v0(70)]", views: postTextView)
        addConstraintsWithFormat(format: "V:|-\(centerY)-[v0]-\(centerY)-|", views: sendButton) 

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if postTextView.text == "Gönderi yazın."{
            textView.text = ""
            textView.textColor = .black
        }
        postTimer?.invalidate()
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if postTextView.text == ""{
            postTextView.text = "Gönderi yazın."
            postTextView.textColor = .lightGray
            
            
//            postTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(PostsController.getPostWithoutHashtag), userInfo: nil, repeats: true)
        }

    }

    @objc func buttonAction(sender: UIButton!) {
        //Gonder butonu islemleri
        print("gonderBakalim")
        if !postTextView.text.isEmpty {
            if let post = postTextView.text{
                print(post)
                Post.postStruct(text: post, lat: lat, lon: lon, country: country, city: city)
                postTextView.text=""
                postTextView.endEditing(true)
            }
        }
        
    }
    //Location
    fileprivate func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.lat = locations[0].coordinate.latitude.description
        self.lon = locations[0].coordinate.longitude.description
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude , longitude: locations[0].coordinate.longitude)
        
        requestLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
            if let placemark = placemarks{
                if placemark.count > 0 {
                    self.city = (placemark[0].subAdministrativeArea)!
                    self.country = placemark[0].country!
                }
            }
        }
    }
    
}

