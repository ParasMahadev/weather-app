//
//  WeatherServiceError.swift
//  WeatherApp
//
//  Created by Paras Navadiya on 10/1/24.
//

import Foundation

enum WeatherServiceError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingFailed
    case invalidResponse
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .noData:
            return "No data was received from the server."
        case .decodingFailed:
            return "Failed to decode the data from the server."
        case .networkError(let error):
            return error.localizedDescription
        case .invalidResponse:
            return "The response from the server was invalid."
        }
    }
}
