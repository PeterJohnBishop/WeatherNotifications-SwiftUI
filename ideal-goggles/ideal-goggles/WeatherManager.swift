//
//  WeatherManager.swift
//  ideal-goggles
//
//  Created by m1_air on 6/23/24.
//

import Foundation
import WeatherKit

@Observable class WeatherManager {
    private let weatherService = WeatherService()
    var weather: Weather?
    
    func getWeather(lat: Double, long: Double) async {
            do {
                weather = try await Task.detached(priority: .userInitiated) { [weak self] in
                    return try await self?.weatherService.weather(for: .init(latitude: lat, longitude: long))
                }.value
                
            } catch {
                print("Failed to get weather data. \(error)")
            }
        }

        var icon: String {
            guard let iconName = weather?.currentWeather.symbolName else { return "--" }
            
            return iconName
        }
        
        var temperatureC: String {
            guard let temp = weather?.currentWeather.temperature else { return "--" }
            let convert = temp.converted(to: .celsius).value
            
            return String(Int(convert)) + "C"
        }
    
    var temperatureF: String {
        guard let temp = weather?.currentWeather.temperature else { return "--" }
        let convert = temp.converted(to: .fahrenheit).value
        
        return String(Int(convert)) + "°F"
    }
        
        var humidity: String {
            guard let humidity = weather?.currentWeather.humidity else { return "--" }
            let computedHumidity = humidity * 100
            
            return String(Int(computedHumidity)) + "%"
        }
}
