//
//  UITestKey.swift
//  WeatherSwift
//
//  Created by Romain Mullot on 02/02/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import Foundation

enum UITestingIdentifiers: String {
  case descriptionViewController
  case weatherCollectionViewController
}

enum UITestLaunchArgument: String {
  case uiTesting = "UI-Testing"

  static var isEnabled: Bool {
    ProcessInfo.processInfo.arguments.contains(UITestLaunchArgument.uiTesting.rawValue)
  }
}
