//
//  WeatherLocation.swift
//  WeatherMS
//
//  Created by Nikolai Eremenko on 03.05.2023.
//

import Foundation

class WeatherLocation: Codable {
    var name: String
    var latitude: Double
    var longitude: Double
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func getData() {
        let urlString = "https://api.openweathermap.org/data/3.0/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely&units=metric&appid=\(APIkeys.openWeatherKey)"
        
        print("🕸️ We are accessing the url \(urlString)")
        
        // Create URL
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not load url from urlString")
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
                let json = try JSONSerialization.jsonObject(with: data!)
                print("😎 \(json)")
            } catch {
                print("😡 ERROR: \(error.localizedDescription)")
            }
        }
        
        task.resume()
        
    }
}
