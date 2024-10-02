//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Paras Navadiya on 10/1/24.
//

import SwiftUI

@main
struct WeatherApp: App {
    let navigationController = UINavigationController()
    let coordinator = WeatherCoordinator(navigationController: UINavigationController())

    var body: some Scene {
        WindowGroup {
            WeatherView(viewModel: WeatherViewModel(), coordinator: coordinator)
        }
    }
}
