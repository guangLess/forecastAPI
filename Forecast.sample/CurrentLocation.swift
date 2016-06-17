//
//  CurrentLocation.swift
//  Forecast.sample
//
//  Created by Guang on 6/14/16.
//  Copyright © 2016 Guang. All rights reserved.
//

import Foundation
import CoreLocation

class CurrentLocation: NSObject, CLLocationManagerDelegate {
    //TOFIX: locationManagerInstance should be named sharedInstance/
    static let sharedInstance = CurrentLocation()
    let locationManager = CLLocationManager()
    
    func prepareToGetLocation () {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.requestLocation()
    }
    
    var currentCoordinate = CLLocationCoordinate2D()
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        } else {
            print("Can not find location")
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error finding location: \(error.localizedDescription)")
    }
}