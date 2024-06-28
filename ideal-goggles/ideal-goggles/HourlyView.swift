//
//  HourlyView.swift
//  ideal-goggles
//
//  Created by m1_air on 6/27/24.
//

import SwiftUI
import WeatherKit

struct HourlyView: View {
    @Binding var forecast: [HourWeather]
    @Binding var celsius: Bool 
    let calendar = Calendar.current
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 30){
                ForEach(forecast, id: \.date){
                    hour in
                    if(hour.date >= Date.now) {
                        VStack{
                            Image(systemName: hour.symbolName)
                            
                            let temp = celsius ?
                            hour.temperature.converted(to: .celsius).value :
                            hour.temperature.converted(to: .fahrenheit).value
                            celsius ?
                            Text(String("\(Int(temp))° C")) :
                            Text(String("\(Int(temp))° F"))
                            HStack{
                                calendar.component(.hour, from: hour.date) == calendar.component(.hour, from: Date.now) ? Text(" Now").fontWeight(.bold) :
                                calendar.component(.hour, from: hour.date) == 0 ?
                                Text(String(describing: calendar.component(.hour, from: hour.date) + 12)).fontWeight(.light) :
                                calendar.component(.hour, from: hour.date) <= 12 ?
                                Text(String(describing: calendar.component(.hour, from: hour.date))) :
                                Text(String(describing: calendar.component(.hour, from: hour.date) - 12))
                                calendar.component(.hour, from: hour.date) == calendar.component(.hour, from: Date.now) ? Text("") :
                                calendar.component(.hour, from: hour.date) < 12 ? Text("am") : Text("pm")
                            }
                            Text("\(String(describing: calendar.component(.month, from: hour.date))) / \(String(describing: calendar.component(.day, from: hour.date)))").fontWeight(.ultraLight)
                        }
                    }
                }
            }
        }.NeumorphicStyle()
    }
}


