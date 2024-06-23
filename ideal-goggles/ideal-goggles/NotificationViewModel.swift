//
//  NotificationViewModel.swift
//  ideal-goggles
//
//  Created by m1_air on 6/21/24.
//

import Foundation
import Observation
import MapKit

@Observable class NotificationView {
    var notif: NotificationData = NotificationData(id: UUID().uuidString, name: "", temp: 0.0, long: 0.0, lat: 0.0, address: "", celcius: false, active: false, alert: false)
    var notifs: [NotificationData] = []
    var message: String = ""
    
    func convertTemp() {
        if(self.notif.celcius == false) {
            let f = self.notif.temp
            self.notif.temp = (f-32)*(5/9)
            self.notif.celcius = true
        } else {
            let c = self.notif.temp
            self.notif.temp = (c*(9/5))+32
            self.notif.celcius = false
        }
    }
    
    
    
    func forwardGeocoding() {
            let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(self.notif.address, completionHandler: { (placemarks, error) in
                if error != nil {
                    self.message = "Failed to retrieve location. \(String(describing: error?.localizedDescription))"
                    return
                }
                
                var location: CLLocation?
                
                if let placemarks = placemarks, placemarks.count > 0 {
                    location = placemarks.first?.location
                }
                
                if let location = location {
                    let coordinate = location.coordinate
                    self.notif.lat = coordinate.latitude
                    self.notif.long = coordinate.longitude
                }
                else
                {
                    print("No Matching Location Found")
                }
            })
        }
    
    func reverseGeocoding() {
            let geocoder = CLGeocoder()
        let location = CLLocation(latitude: self.notif.lat, longitude: self.notif.long)
            geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    self.message = "Failed to retrieve address \(String(describing: error?.localizedDescription))"
                    return
                }
                
                if let placemarks = placemarks, let placemark = placemarks.first {
                    print(placemarks)
                    self.notif.address = String("\(placemark.thoroughfare ?? ""), \(placemark.subThoroughfare ?? ""), \(placemark.locality ?? ""), \(placemark.subLocality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.subAdministrativeArea ?? ""), \(placemark.postalCode ?? "")")
                }
                else
                {
                    print("No Matching Address Found")
                    self.notif.address = "No Address Found"
                }
            })
        }
    
    
}
