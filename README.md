# WeatherMS
WeatherMS – mimic the functionality of Apple’s weather app. I use Swift and iOS to access real-time weather data and learn to make API calls and parse returned JSON data.  I also use the Google Place Autocomplete to access any location in Google’s vast place database, and then get weather for that locale. This app emphasizes well-structured MVC code style, custom classes, and introduces the collection view and page view controller iOS interface elements.
WeatherMS app using data from the OpenWeather and Google Places

# Compatibility
This project is written in Swift 5 and requires Xcode 13+ to build and run.

# Demo
![Simulator Screen Recording - iPhone 14 Pro - 2023-06-04 at 13 33 09](https://github.com/xcode73/WeatherMS/assets/11060275/340408cc-fa88-4c67-93f1-5c23f8f4f5ed)

# Features
Swift Programming Language

# How to build
1. Clone the repository

```
$ git clone https://github.com/xcode73/WeatherMS.git
```

3. Install pods

```
$ cd WeatherMS
$ pod install
```

5. Open the workspace in Xcode

```
$ open "WeatherMS.xcworkspace"
```

7. Sign up on ([openweathermap.org/appid](https://openweathermap.org/appid)) to get an appid
8. Sign up on ([developers.google.com](https://developers.google.com/maps/documentation/places/web-service/overview)) to get an appid
9. Create file APIkeys.swift copy and paste code below

```
struct APIkeys {
    static let googlePlacesKey = "your-googleplaces-key"
    static let openWeatherKey = "your-openweathermap-appid"
}
```

*Please replace "your-googleplaces-key" and "your-openweathermap-appid" with your actual appid key.*
10. Compile and run the app in your simulator
11. If you don't see any data, please check "Simulator" -> "Debug" -> "Location" to change the location.

# Requirements
- Xcode 13
- iOS 14+
- Swift 5
