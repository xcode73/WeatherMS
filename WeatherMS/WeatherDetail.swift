//
//  WeatherDetail.swift
//  WeatherMS
//
//  Created by Nikolai Eremenko on 08.05.2023.
//

import Foundation
import UIKit

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
    return dateFormatter
}()

private let hourFormatter: DateFormatter = {
    let hourFormatter = DateFormatter()
    hourFormatter.setLocalizedDateFormatFromTemplate("H")
    return hourFormatter
}()

struct DailyWeather {
    var dailyIcon: String
    var dailyWeekday: String
    var dailySummary: String
    var dailyHigh: Int
    var dailyLow: Int
}

struct HourlyWeather {
    var hour: String
    var hourlyTemperarure: Int
    var hourlyIcon: String
}

class WeatherDetail: WeatherLocation {
    
    private struct Result: Codable {
        var timezone: String
        var current: Current
        var daily: [Daily]
        var hourly: [Hourly]
    }
    
    private struct Current: Codable {
        var dt: TimeInterval
        var temp: Double
        var weather: [Weather]
    }
    
    private struct Weather: Codable {
        var description: String
        var icon: String
        var id: Int
    }
    
    private struct Daily: Codable {
        var dt: TimeInterval
        var temp: Temp
        var weather: [Weather]
    }
    
    private struct Hourly: Codable {
        var dt: TimeInterval
        var temp: Double
        var weather: [Weather]
    }
    
    private struct Temp: Codable {
        var max: Double
        var min: Double
        
    }
    
    var timezone = ""
    var currentTime = 0.0
    var temperature = 0
    var summary = ""
    var dayIcon = ""
    var dailyWeatherData: [DailyWeather] = []
    var hourlyWeatherData: [HourlyWeather] = []
    
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
                self.dayIcon = self.fileNameForIcon(icon: result.current.weather[0].icon)
                for index in 0..<result.daily.count {
                    let weekdayDate = Date(timeIntervalSince1970: result.daily[index].dt)
                    dateFormatter.timeZone = TimeZone(identifier: result.timezone)
                    let dailyWeekday = dateFormatter.string(from: weekdayDate)
                    let dailyIcon = self.fileNameForIcon(icon: result.daily[index].weather[0].icon)
                    let dailySummary = result.daily[index].weather[0].description
                    let dailyHigh = Int(result.daily[index].temp.max.rounded())
                    let dailyLow = Int(result.daily[index].temp.min.rounded())
                    let dailyWeather = DailyWeather(dailyIcon: dailyIcon, dailyWeekday: dailyWeekday, dailySummary: dailySummary, dailyHigh: dailyHigh, dailyLow: dailyLow)
                    self.dailyWeatherData.append(dailyWeather)
                    print("Day: \(dailyWeekday), High: \(dailyHigh), Low: \(dailyLow)")
                }
                
                // get no more than 24 hrs of hourly data
                let lastHour = min(24, result.hourly.count)
                if lastHour > 0 {
                    for index in 1...lastHour {
                        let hourlyDate = Date(timeIntervalSince1970: result.hourly[index].dt)
                        hourFormatter.timeZone = TimeZone(identifier: result.timezone)
                        let hour = hourFormatter.string(from: hourlyDate)
//                        let hourlyIcon = self.fileNameForIcon(icon: result.hourly[index].weather[0].icon)
                        let hourlyIcon = self.systemNameFromId(id: result.hourly[index].weather[0].id, icon: result.hourly[index].weather[0].icon)
                        let hourlyTemperature = Int(result.hourly[index].temp.rounded())
                        let hourlyWeather = HourlyWeather(hour: hour, hourlyTemperarure: hourlyTemperature, hourlyIcon: hourlyIcon)
                        self.hourlyWeatherData.append(hourlyWeather)
                        print("Hour: \(hour), Temperature: \(hourlyTemperature), Icon: \(hourlyIcon)")
                    }
                }
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
    
    private func systemNameFromId(id: Int, icon: String) -> String {
        switch id {
        case 200...299:
            return "cloud.bolt.rain"
        case 300...3999:
            return "cloud.drizzle"
        case 500, 501, 520, 521, 531:
            return "cloud.rain"
        case 502, 503, 504, 522:
            return "cloud.heavyrain"
        case 511, 611...616:
            return "sleet"
        case 600...602, 620...622:
            return "snow"
        case 701, 711, 741:
            return "cloud.fog"
        case 721:
            return (icon.hasSuffix("d") ? "sun.haze" : "cloud.fog")
        case 731, 751, 761, 762:
            return (icon.hasSuffix("d") ? "sun.dust" : "cloud.fog")
        case 771:
            return "wind"
        case 781:
            return "tornado"
        case 800:
            return (icon.hasSuffix("d") ? "sun.max" : "moon")
        case 801, 802:
            return (icon.hasSuffix("d") ? "cloud.sun" : "cloud.moon")
        case 803,804:
            return "cloud"
        default:
            return "questionmark.diamond"
        }
    }
}
