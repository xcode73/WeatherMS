//
//  WeatherDetail.swift
//  WeatherMS
//
//  Created by Nikolai Eremenko on 08.05.2023.
//

import Foundation
import UIKit

class WeatherDetail: WeatherLocation {
    
    struct Result: Codable {
        var timezone: String
        var current: Current
    }
    
    struct Current: Codable {
        var dt: TimeInterval
        var temp: Double
        var weather: [Weather]
    }
    
    struct Weather: Codable {
        var description: String
        var icon: String
    }
    
    var timezone = ""
    var currentTime = 0.0
    var temperature = 0
    var summary = ""
    var dailyIcon = ""
    
    func getData(completed: @escaping() -> ()) {
        let urlString = "https://api.openweathermap.org/data/3.0/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely&units=metric&appid=\(APIkeys.openWeatherKey)"
        
        print("🕸️ We are accessing the url \(urlString)")
        
        // Create URL
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not load url from urlString")
            completed()
            return
        }
        
        // Create Session
        let session = URLSession.shared
        
        // get data with dataTask method
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("😡 ERROR: \(error.localizedDescription)")
            }
            
            // NOTE: There are some additional things that could go wrong when using urlSession, but we shouldn't expirience them, so we'll ignore testing these for now...
            
            // deal with the data
            do {
                let result = try JSONDecoder().decode(Result.self, from: data!)
                self.timezone = result.timezone
                self.currentTime = result.current.dt
                self.temperature = Int(result.current.temp.rounded())
                self.summary = result.current.weather[0].description
                self.dailyIcon = self.fileNameForIcon(icon: result.current.weather[0].icon)
            } catch {
                print("😡 ERROR: \(error.localizedDescription)")
            }
            completed()
        }
        task.resume()
    }
    
    private func fileNameForIcon(icon: String) -> String {
        var newFileName = ""
        switch icon {
        case "01d":
            newFileName = "sun.max"
        case "01n":
            newFileName = "moon.zzz"
        case "02d":
            newFileName = "cloud.sun"
        case "02n":
            newFileName = "cloud.moon"
        case "03d":
            newFileName = "cloud"
        case "03n":
            newFileName = "cloud"
        case "04d":
            newFileName = "cloud"
        case "04n":
            newFileName = "cloud"
        case "09d":
            newFileName = "cloud.drizzle"
        case "09n":
            newFileName = "cloud.drizzle"
        case "10d":
            newFileName = "cloud.sun.rain"
        case "10n":
            newFileName = "cloud.moon.rain"
        case "11d":
            newFileName = "cloud.bolt"
        case "11n":
            newFileName = "cloud.bolt"
        case "13d":
            newFileName = "snow"
        case "13n":
            newFileName = "snow"
        case "50d":
            newFileName = "cloud.fog"
        case "50n":
            newFileName = "cloud.fog"
        default:
            newFileName = ""
        }
        return newFileName
    }
}
