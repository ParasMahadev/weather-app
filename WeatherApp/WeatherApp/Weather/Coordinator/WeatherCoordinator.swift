//
//  WeatherCoordinator.swift
//  WeatherApp
//
//  Created by Paras Navadiya on 10/1/24.
//


import UIKit
import SwiftUI

class WeatherCoordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = WeatherViewModel()
        let weatherView = WeatherView(viewModel: viewModel, coordinator: self)
        let viewController = UIHostingController(rootView: weatherView)
        navigationController.pushViewController(viewController, animated: true)
    }
}
