//
//  Weather+Fetchable.swift
//  WeatherSwift
//
//  Created by Romain Mullot on 16/11/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation
import CoreData

extension Forecast: Fetchable {

  public typealias FetchableType = Forecast

  static public var entityName: String {
    return "Forecast"
  }

}
