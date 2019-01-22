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

  /// Return a converted date
  public func toParsedDate() -> NSDate {
    guard self.isNotEmpty else { return NSDate() }
    guard let date = FormatterService.sharedInstance.parserDateFormatter().date(from: self) else { return NSDate() }
    return date as NSDate
  }

}
