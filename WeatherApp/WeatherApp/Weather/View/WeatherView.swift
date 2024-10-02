//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Paras Navadiya on 10/1/24.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel
    var coordinator: WeatherCoordinator  // Coordinator dependency
    
    @StateObject private var locationManager = LocationManager()
    
    // Access the horizontal and vertical size classes
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        NavigationView {
            ZStack {
                // Gradient background
                LinearGradient(
                    gradient: Gradient(colors: [.blue, .green]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                Group {
                    if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                        // Portrait layout
                        VStack {
                            weatherContent()
                        }
                    } else {
                        // Landscape layout
                        HStack {
                            weatherContent()
                        }
                    }
                }
                .padding()
            }.navigationTitle("Weather Forecast")
        }
        .onAppear {
            if let location = locationManager.location {
                Task {
                    await viewModel.fetchWeatherByLocation(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                }
            }
        }
        .onChange(of: locationManager.location) { location in
            if let location = location {
                Task {
                    await viewModel.fetchWeatherByLocation(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                }
            }
        }
    }
    
    // Extracted weather content to be used in both layouts
    @ViewBuilder
    private func weatherContent() -> some View {
    
        TextField("Enter city name", text: Binding(
            get: { locationManager.cityName.isEmpty ? viewModel.city : locationManager.cityName },
            set: { viewModel.city = $0 }
        ))
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
        
        // Toggle to switch between Celsius and Fahrenheit
        Toggle(isOn: $viewModel.isFahrenheit) {
            Text(viewModel.isFahrenheit ? "Display in Fahrenheit" : "Display in Celsius")
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(10)
        .padding()
        
        if let weather = viewModel.weather {
            VStack {
                Text(weather.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top)
                
                // Temperature display based on the selected unit
                Text(viewModel.convertTemperature(weather.main.temp))
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.top)
                
                Text(weather.weather.first?.description.capitalized ?? "")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.bottom)
                
                if let iconCode = weather.weather.first?.icon {
                    // Use WeatherEndpoint to get the icon URL
                    let iconURL = WeatherEndpoint(type: .weatherIcon(iconCode)).getURL()
                    // Use AsyncImage to load the icon
                    AsyncImage(url: iconURL)
                        .frame(width: 100, height: 100)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.2)))
            .shadow(radius: 10)
        }
    }
}

#Preview {
    WeatherView(viewModel: WeatherViewModel(), coordinator: WeatherCoordinator(navigationController: UINavigationController()))
}
