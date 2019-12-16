//
//  Weather.swift
//  weatherapp
//

import Foundation

struct Weather: Decodable {
    let title: String?
    let weatherElements: [WeatherElement]?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case weatherElements = "consolidated_weather"
    }
}

struct WeatherElement: Decodable {
    let id: Int
    let weatherStateName: String?
    let weatherStateAbbr: String?
    let windDirectionCompass: String?
    let created: String?
    let applicableDate: String?
    let minTemp: Double?
    let maxTemp: Double?
    let theTemp: Double?
    let windSpeed: Double?
    let windDirection: Double?
    let airPressure: Double?
    let humidity: Int?
    let visibility: Double?
    let predictability: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case weatherStateName = "weather_state_name"
        case weatherStateAbbr = "weather_state_abbr"
        case windDirectionCompass = "wind_direction_compass"
        case created = "created"
        case applicableDate = "applicable_date"
        case minTemp = "min_temp"
        case maxTemp = "max_temp"
        case theTemp = "the_temp"
        case windSpeed = "wind_speed"
        case windDirection = "wind_direction"
        case airPressure = "air_pressure"
        case humidity = "humidity"
        case visibility = "visibility"
        case predictability = "predictability"
    }
}
