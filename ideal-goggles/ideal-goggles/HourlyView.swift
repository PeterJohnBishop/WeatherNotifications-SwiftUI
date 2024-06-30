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
        ZStack{
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)).NeumorphicStyleBlk()
            Color(.white).opacity(0.2)
            ScrollView(.horizontal) {
                HStack(spacing: 30){
                    ForEach(forecast, id: \.date){
                        hour in
                        if(hour.date >= Date.now) {
                            VStack{
                                Image(systemName: hour.symbolName).foregroundStyle(.white).fontWeight(.ultraLight)
                                
                                let temp = celsius ?
                                hour.temperature.converted(to: .celsius).value :
                                hour.temperature.converted(to: .fahrenheit).value
                                celsius ?
                                Text(String("\(Int(temp))° C")).foregroundColor(.white) :
                                Text(String("\(Int(temp))° F")).foregroundColor(.white)
                                HStack{
                                    calendar.component(.hour, from: hour.date) == calendar.component(.hour, from: Date.now) ? Text(" Now").foregroundColor(.white).fontWeight(.bold) :
                                    calendar.component(.hour, from: hour.date) == 0 ?
                                    Text(String(describing: calendar.component(.hour, from: hour.date) + 12)).foregroundColor(.white).fontWeight(.light) :
                                    calendar.component(.hour, from: hour.date) <= 12 ?
                                    Text(String(describing: calendar.component(.hour, from: hour.date))).foregroundStyle(.white) :
                                    Text(String(describing: calendar.component(.hour, from: hour.date) - 12)).foregroundStyle(.white)
                                    calendar.component(.hour, from: hour.date) == calendar.component(.hour, from: Date.now) ? Text("") :
                                    calendar.component(.hour, from: hour.date) < 12 ? Text("am").foregroundColor(.white) : Text("pm").foregroundColor(.white)
                                }
                                Text("\(String(describing: calendar.component(.month, from: hour.date))) / \(String(describing: calendar.component(.day, from: hour.date)))").foregroundColor(.white).fontWeight(.ultraLight)
                            }
                        }
                    }
                }
            }
        }
            
    }
}


