//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Paras Navadiya on 10/1/24.
//

import XCTest
@testable import WeatherApp

class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var mockWeatherAPIService: MockWeatherAPIService!

    override func setUp() {
        super.setUp()
        
        mockWeatherAPIService = MockWeatherAPIService()
        viewModel = WeatherViewModel(weatherService: mockWeatherAPIService)
    }

    override func tearDown() {
        viewModel = nil
        mockWeatherAPIService = nil
        super.tearDown()
    }

    // Test case for fetching weather by city name
    func testFetchWeatherByCityName_Success() async {
        let expectedWeather = Weather(main: Weather.Main(temp: 25.0, humidity: 80),
                                      weather: [Weather.WeatherDetail(description: "Clear", icon: "01d")],
                                      name: "Plano")
        mockWeatherAPIService.weatherResult = .success(expectedWeather)

        await viewModel.fetchWeather()

        XCTAssertEqual(viewModel.weather?.name, expectedWeather.name)
        XCTAssertEqual(viewModel.weather?.main.temp, expectedWeather.main.temp)
    }

    // Test case for handling API failure by city name
    func testFetchWeatherByCityName_Failure() async {
        mockWeatherAPIService.weatherResult = .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch weather"]))

        await viewModel.fetchWeather()

        XCTAssertNil(viewModel.weather)
    }

    // Test case for fetching weather by location - Success
    func testFetchWeatherByLocation_Success() async {
        let expectedWeather = Weather(main: Weather.Main(temp: 30.0, humidity: 70),
                                      weather: [Weather.WeatherDetail(description: "Sunny", icon: "01d")],
                                      name: "San Francisco")
        mockWeatherAPIService.weatherResult = .success(expectedWeather)

        await viewModel.fetchWeatherByLocation(lat: 37.7749, lon: -122.4194)

        XCTAssertEqual(viewModel.weather?.name, expectedWeather.name)
        XCTAssertEqual(viewModel.weather?.main.temp, expectedWeather.main.temp)
    }

    // Test case for fetching weather by location - Failure
    func testFetchWeatherByLocation_Failure() async {
        mockWeatherAPIService.weatherResult = .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch weather"]))

        await viewModel.fetchWeatherByLocation(lat: 37.7749, lon: -122.4194)

        XCTAssertNil(viewModel.weather)
    }
}

class MockWeatherAPIService: WeatherServiceProtocol {
    var weatherResult: Result<Weather, Error>?

    // Initializer for the mock service
    init(weatherResult: Result<Weather, Error>? = nil) {
        self.weatherResult = weatherResult
    }

    func fetchWeather(for city: String) async throws -> Weather {
        if let result = weatherResult {
            switch result {
            case .success(let weather):
                return weather
            case .failure(let error):
                throw error
            }
        }
        throw WeatherServiceError.noData
    }

    func fetchWeatherByLocation(lat: Double, lon: Double) async throws -> Weather {
        if let result = weatherResult {
            switch result {
            case .success(let weather):
                return weather
            case .failure(let error):
                throw error
            }
        }
        throw WeatherServiceError.noData
    }
}
