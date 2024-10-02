//
//  WeatherEndpoint.swift
//  WeatherApp
//
//  Created by Paras Navadiya on 10/1/24.
//

import Foundation

class WeatherEndpoint {
    private let apiKey = "4ebe356ae99a4ed1550725578757b5b1"  // Replace with your actual API key
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let iconBaseURL = "https://openweathermap.org/img/wn/"
    
    enum EndpointType {
        case city(String)
        case coordinates(Double, Double)
        case weatherIcon(String) 
    }
    
    let type: EndpointType
    
    init(type: EndpointType) {
        self.type = type
    }
    
    func getURL() -> URL? {
        var urlString = ""
        
        switch type {
        case .city(let city):
            urlString = "\(baseURL)?q=\(city),US&appid=\(apiKey)&units=metric" // Only Allowed US Cities as per requirements
        case .coordinates(let lat, let lon):
            urlString = "\(baseURL)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        case .weatherIcon(let iconCode):
            urlString = "\(iconBaseURL)\(iconCode)@2x.png"
        }
        
        return URL(string: urlString)
    }
}
