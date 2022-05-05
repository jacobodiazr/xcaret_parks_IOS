//
//  LocationSingleton.swift
//  XCARET!
//
//  Created by Angelica Can on 7/12/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import CoreLocation

class LocationSingleton: NSObject, CLLocationManagerDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let shared = LocationSingleton()
    private let locationManager = CLLocationManager()
    private var latitude : Double = 0.0
    private var longitude : Double = 0.0
    var intoThePark : Bool = false
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization() // you might replace this with whenInuse
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
           print("\(location)")
           let coords = manager.location?.coordinate
            latitude = coords!.latitude
            longitude = coords!.longitude
            if inThePark(){
                intoThePark = true
            }else{
                intoThePark = false
            }
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    private func getLatitude() -> CLLocationDegrees {
        return latitude
    }
    
    private func getLongitude() -> CLLocationDegrees {
        return longitude
    }
    
    func startLocation(){
        self.locationManager.startUpdatingLocation()
    }
    
    func inThePark() -> Bool {
        let coord1 = CLLocation(latitude: latitude, longitude: longitude)
        let coord2 = CLLocation(latitude: self.appDelegate.itemMapSelected.latitude, longitude: self.appDelegate.itemMapSelected.longitude)
        let distance = ceil(coord1.distance(from: coord2) / 1000)
        return distance <= self.appDelegate.itemMapSelected.radiusLimit
    }
    
}
