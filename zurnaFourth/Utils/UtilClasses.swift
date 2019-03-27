//
//  UtilClasses.swift
//  zurnaFourth
//
//  Created by Yavuz on 26.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//
import UIKit
import CoreLocation

class FindLocation: CLLocation, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var requestLocation = CLLocation()

    var mark = "dene"
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupLocation()
//    }

    func getLocation(){
        let lat = CLLocation().coordinate.latitude
        let lon = CLLocation().coordinate.longitude
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        requestLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
            if let placemark = placemarks{
                if placemark.count > 0 {
//                    self.mark = (placemark[0].administrativeArea)!
                    
                    print("Location icinde \(String(describing: placemark[0].country))")
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)

        requestLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)

        CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
            if let placemark = placemarks{
                if placemark.count > 0 {

                    self.mark = (placemark[0].administrativeArea)!
                    print("Location icinde \(self.mark)")
                }
            }
        }
    }
}
