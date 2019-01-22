//
//  String+WeatherCore.swift
//  WeatherCore
//
//  Created by Romain Mullot on 22/01/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import Foundation

extension String {

  /// Return a boolean checking if the string is not empty
  public var isNotEmpty: Bool {
    return !self.isEmpty
  }

  /// convert Kelvin temperature in Celsius temperature
  /// - Returns: A float value coresponding to a celsius temperature
  public func isUrl(completionHandler: @escaping (Bool, URL?) -> Void) {
    guard self.isNotEmpty else { return completionHandler(false, nil) }
    if let url = URL(string: self) {
      // check if your application can open the URL instance
      return completionHandler(UIApplication.shared.canOpenURL(url), url)
    }
    return completionHandler(false, nil)
  }

}
