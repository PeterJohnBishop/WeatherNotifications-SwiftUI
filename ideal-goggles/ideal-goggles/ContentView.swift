//
//  ContentView.swift
//  ideal-goggles
//
//  Created by m1_air on 6/15/24.
//

import SwiftUI
import SwiftData
import MapKit
// nice
struct ContentView: View {
    @State var ready: Bool = false
    @State var buttonText: String = ""
    var locationManager: LocationManager = LocationManager()
    
    var body: some View {
        ZStack{
            if(ready)
            {
                DialView()
            } else {
                VStack{
                    Text(buttonText).foregroundStyle(.red)
                    Button(action: {
                        if(locationManager.manager.authorizationStatus == .authorizedAlways || locationManager.manager.authorizationStatus == .authorizedWhenInUse) {
                            ready = true
                        } else {
                            buttonText = "Location Services Required.  Reinstall to try again."
                        }
                    }, label: {
                        Text("GO").foregroundStyle(.black)
                    })
                }
            }
        }.onAppear{
            locationManager.manager.requestWhenInUseAuthorization()
            if(locationManager.manager.authorizationStatus == .authorizedAlways || locationManager.manager.authorizationStatus == .authorizedWhenInUse) {
                ready = true
            }
        }
        
    }
}

#Preview {
    ContentView()
}


