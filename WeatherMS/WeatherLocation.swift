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
}
