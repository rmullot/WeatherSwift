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

  public func isUrl(_ completionHandler: @escaping (Bool, URL?) -> Void ) {
    guard self.isNotEmpty, let url = URL(string: self) else {
      return completionHandler(false, nil)
    }
    return completionHandler(UIApplication.shared.canOpenURL(url), url)

  }

  /// Return a converted date
  public func toParsedDate() -> NSDate {
    guard self.isNotEmpty else { return NSDate() }
    guard let date = FormatterService.sharedInstance.parserDateFormatter().date(from: self) else { return NSDate() }
    return date as NSDate
  }

}
