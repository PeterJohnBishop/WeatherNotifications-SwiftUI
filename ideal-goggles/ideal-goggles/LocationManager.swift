//
//  LocationManager.swift
//  ideal-goggles
//
//  Created by m1_air on 6/21/24.
//

import Foundation
import Observation
import CoreLocation

@Observable class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    var location: CLLocationCoordinate2D?
    var degrees: Double = 0
    var authStatus: CLAuthorizationStatus = .notDetermined
    var success: Bool = false

    let manager = CLLocationManager()
    
    func requestLocation() -> CLLocation {
        authStatus = manager.authorizationStatus
        manager.requestLocation()
        return manager.location!
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    override init() {
        super.init()
        manager.delegate = self
        manager.startUpdatingHeading()
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        degrees = newHeading.trueHeading
    }
    
    
}
