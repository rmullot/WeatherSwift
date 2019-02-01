//
//  NavigationService.swift
//  Diagnostic
//
//  Created by Romain Mullot on 11/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation
import UIKit
import WeatherCore

public protocol NavigationServiceProtocol {
  func navigateToDescription(forecast: Forecast)
}

public final class NavigationService: NavigationServiceProtocol {

  // MARK: - Attributes

  static let sharedInstance = NavigationService()

  private var navigationController: UINavigationController {
    guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
      fatalError()
    }
    return navigationController
  }

  // MARK: - Methods

  public func navigateToDescription(forecast: Forecast) {
    guard navigationController.visibleViewController is WeatherTableViewController  else { return }
    if let descriptionViewController = loadViewController("DescriptionViewController") as? DescriptionViewController {
      descriptionViewController.viewModel = DescriptionViewModel(forecast: forecast)
      navigationController.pushViewController(descriptionViewController, animated: true)
    }
  }

  // MARK: - Private Methods

  private init() {}

  private func loadViewController(_ identifier: String) -> UIViewController {
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
  }
}
