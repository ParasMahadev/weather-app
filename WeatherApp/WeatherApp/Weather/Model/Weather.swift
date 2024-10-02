//
//  Weather.swift
//  WeatherApp
//
//  Created by Paras Navadiya on 10/1/24.
//

import Foundation

struct Weather: Codable {
    let main: Main
    let weather: [WeatherDetail]
    let name: String

    struct Main: Codable {
        let temp: Double
        let humidity: Int
    }

    struct WeatherDetail: Codable {
        let description: String
        let icon: String
        
        var iconURL: URL {
            return WeatherEndpoint(type: .weatherIcon(icon)).getURL()!
        }
    }
}

