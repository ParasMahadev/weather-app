//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Paras Navadiya on 10/1/24.
//

import Foundation

class WeatherViewModel: ObservableObject {
    @Published var city: String = UserDefaults.standard.string(forKey: "LastSearchedCity") ?? "" {
        didSet {
            debounceFetchWeather()
        }
    }
    
    @Published var weather: Weather?
    @Published var isFahrenheit: Bool = false  // Toggle state for temperature unit

    private let weatherService: WeatherServiceProtocol
    private var debounceTimer: Timer?

    // Dependency injection for the weather service
    init(weatherService: WeatherServiceProtocol = WeatherService.shared) {
        self.weatherService = weatherService
        
        // Automatically fetch weather for the last searched city on app launch
        if !city.isEmpty {
            Task {
                await fetchWeather()
            }
        }
    }

    // Fetch weather by city name
    func fetchWeather() async {
        do {
            let fetchedWeather = try await weatherService.fetchWeather(for: city)
            DispatchQueue.main.async {
                self.weather = fetchedWeather
                // Save the last searched city to UserDefaults
                UserDefaults.standard.set(self.city, forKey: "LastSearchedCity")
            }
        } catch {
            print("Error fetching weather: \(error.localizedDescription)")
        }
    }
    
    // Fetch weather by location coordinates
    func fetchWeatherByLocation(lat: Double, lon: Double) async {
        do {
            let fetchedWeather = try await weatherService.fetchWeatherByLocation(lat: lat, lon: lon)
            DispatchQueue.main.async {
                self.weather = fetchedWeather
                // Optionally, you can update the city name here if needed.
            }
        } catch {
            print("Error fetching weather by location: \(error.localizedDescription)")
        }
    }

    // Debounce method to limit API calls when typing city name
    private func debounceFetchWeather() {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            Task {
                await self?.fetchWeather()
            }
        }
    }
    
    // Function to convert temperature based on the toggle state
    func convertTemperature(_ tempInCelsius: Double) -> String {
        if isFahrenheit {
            let tempInFahrenheit = (tempInCelsius * 9/5) + 32
            return String(format: "%.0f°F", tempInFahrenheit)
        } else {
            return String(format: "%.0f°C", tempInCelsius)
        }
    }
}
