//
//  UserDataModel.swift
//  ideal-goggles
//
//  Created by m1_air on 6/16/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model class UserData {
    var id: String = UUID().uuidString
    var name: String
    var email: String
    var password: String
    
    init(id: String, name: String, email: String, password: String) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
    }
}
