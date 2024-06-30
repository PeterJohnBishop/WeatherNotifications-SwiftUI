//
//  CurrentView.swift
//  ideal-goggles
//
//  Created by m1_air on 6/27/24.
//

import SwiftUI
import WeatherKit

struct CurrentView: View {
    @Binding var weather: Weather?
    @Binding var celsius: Bool
    @Binding var address: String

    var body: some View {
                    
            VStack{
                Image(systemName: weather?.currentWeather.symbolName ?? "sun.min")
                    .font(.largeTitle)
                celsius ?
                Text("Currently, \(String(Int(weather?.currentWeather.temperature.converted(to: .celsius).value ?? 0)))° C in").fontWeight(.regular) :
                Text("Currently, \(String(Int(weather?.currentWeather.temperature.converted(to: .fahrenheit).value ?? 0)))° F in").fontWeight(.regular)
                Text(address).fontWeight(.ultraLight)
            }
        
    }
}


