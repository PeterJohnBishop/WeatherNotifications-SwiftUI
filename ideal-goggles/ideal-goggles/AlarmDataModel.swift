//
//  AlarmDataModel.swift
//  ideal-goggles
//
//  Created by m1_air on 6/20/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model class AlarmData {
    var id: String = UUID().uuidString
    var temp: Double
    var celcius: Bool
    var active: Bool
    var alert: Bool
    
    init(id: String, temp: Double, celcius: Bool, active: Bool, alert: Bool) {
        self.id = id
        self.temp = temp
        self.celcius = celcius
        self.active = active
        self.alert = alert
    }
}
