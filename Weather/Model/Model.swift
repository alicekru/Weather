//
//  Model.swift
//  Weather
//
//  Created by Alice Krutienko on 21.01.2021.
//

import Foundation

struct WeatherFModel: Codable {
    let dateTime: Int
    let cityName: String
    let pressure: Int
    let humidity: Int
    let weather: WeatherModel
}

struct WeatherFData: Codable {
    let city: City
    let list: [DayData]
}

struct City: Codable {
    let id: Int
    let name: String
}

struct DayData: Codable {
    let dt: Int
    let temp: TempData
    let pressure: Int
    let humidity: Int
    let weather: [Weather]
}

struct TempData: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}

struct WeatherModel: Codable {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let description: String
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String{
        switch conditionId {
        case 500...531:
            return "rainy"    //rain
        case 600...622:
            return "snow"    //Snow
        case 800:
            return "sun"      //clear sky
        default:
            return "cloudy"
        }
    }
}
