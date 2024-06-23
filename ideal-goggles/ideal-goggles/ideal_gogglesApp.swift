//
//  ideal_gogglesApp.swift
//  ideal-goggles
//
//  Created by m1_air on 6/15/24.
//

import SwiftUI
import SwiftData

@main
struct ideal_gogglesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: [NotificationData.self])
    }
}
