//
//  NSDate+DateFormatter.swift
//  WeatherCore
//
//  Created by Romain Mullot on 02/02/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import Foundation

extension NSDate {

  /// Format a date in a string used for a Rest communication in JSON Format
  /// - Returns: A formatted string corresonding at parserDateFormatter configuration
  public func toParsedString() -> String {
    return FormatterService.sharedInstance.parserDateFormatter().string(from: self as Date )
  }

}
