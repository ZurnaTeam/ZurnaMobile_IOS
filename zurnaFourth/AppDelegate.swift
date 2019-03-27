//
//  AppDelegate.swift
//  zurnaFourth
//
//  Created by Yavuz on 13.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

import UIKit
import CoreLocation



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate{

    var window: UIWindow?
    var locationManager = CLLocationManager()
    var requestLocation = CLLocation()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupLocation()
//        UserDefaults.standard.set(false, forKey: "didYouRegister")
        //Register
        let register = UserDefaults.standard.bool(forKey: "didYouRegister")
        if !register{
            didYouRegisterBefore()
        }
        else{
            let id = UserDefaults.standard.string(forKey: "userId")
            if let _id = id{
                Users.getUser(id: _id)
            }
        }
        
        //Begin App
        window = UIWindow()

//        window?.rootViewController = PostsController(collectionViewLayout: UICollectionViewFlowLayout())
        window?.rootViewController = CustomTabBarController()
        
        return true
    }
    //User Register
    func didYouRegisterBefore() {
        let userid = NSUUID().uuidString
        let deviceId = UIDevice.current.identifierForVendor?.uuidString
      
        Users.userRegister(userid: userid,device: deviceId!)
        UserDefaults.standard.set(true, forKey: "didYouRegister")
        UserDefaults.standard.set(userid, forKey: "userId")
    }
    
    //Location
    fileprivate func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lat = locations[0].coordinate.latitude.description
        let lon = locations[0].coordinate.longitude.description
        var city = String()
        var country = String()
        
        UserDefaults.standard.set(lat, forKey: "lat")
        UserDefaults.standard.set(lon, forKey: "lon")
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude , longitude: locations[0].coordinate.longitude)
        
        requestLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
            if let placemark = placemarks{
                if placemark.count > 0 {
                    city = placemark[0].subAdministrativeArea!
                    country = placemark[0].country!
                    UserDefaults.standard.set(city, forKey: "city")
                    UserDefaults.standard.set(country, forKey: "country")
//                    self.city = (placemark[0].subAdministrativeArea)!
//                    self.country = placemark[0].country!
                    print("icerde")
                }
            }
        }
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

