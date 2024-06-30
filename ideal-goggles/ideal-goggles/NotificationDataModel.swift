//
//  NotificationDataModel.swift
//  ideal-goggles
//
//  Created by m1_air on 6/21/24.
//

import Foundation
import SwiftData
import MapKit

@Model class NotificationData {
    var id: String = UUID().uuidString
    var name: String
    var temp: Double
    var long: Double
    var lat: Double
    var address: String
    var celcius: Bool
    var active: Bool
    var alert: Bool
    var date: Date
    
    init(id: String, name: String, temp: Double, long: Double, lat: Double, address: String, celcius: Bool, active: Bool, alert: Bool, date: Date) {
        self.id = id
        self.name = name
        self.temp = temp
        self.long = long
        self.lat = lat
        self.address = address
        self.celcius = celcius
        self.active = active
        self.alert = alert
        self.date = date
    }
}
