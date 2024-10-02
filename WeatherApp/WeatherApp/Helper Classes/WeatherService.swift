//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Paras Navadiya on 10/1/24.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String) async throws -> Weather
    func fetchWeatherByLocation(lat: Double, lon: Double) async throws -> Weather
}

class WeatherService: WeatherServiceProtocol {
    static let shared = WeatherService()  // Singleton instance

    private init() {}
    
    // Fetch weather by city name
    func fetchWeather(for city: String) async throws -> Weather {
        let weatherEndpoint = WeatherEndpoint(type: .city(city))
        
        guard let url = weatherEndpoint.getURL() else {
            throw WeatherServiceError.invalidURL
        }
    
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw WeatherServiceError.invalidResponse
        }
        
        guard let weather = try? JSONDecoder().decode(Weather.self, from: data) else {
            throw WeatherServiceError.decodingFailed
        }
        
        return weather
    }
    
    // Fetch weather by latitude and longitude
    func fetchWeatherByLocation(lat: Double, lon: Double) async throws -> Weather {
        let weatherEndpoint = WeatherEndpoint(type: .coordinates(lat, lon))
        
        guard let url = weatherEndpoint.getURL() else {
            throw WeatherServiceError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw WeatherServiceError.invalidResponse
        }
        
        guard let weather = try? JSONDecoder().decode(Weather.self, from: data) else {
            throw WeatherServiceError.decodingFailed
        }
        
        return weather
    }
}


