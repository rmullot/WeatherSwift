//
//  DescriptionViewModel.swift
//  WeatherSwift
//
//  Created by Romain Mullot on 22/01/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import Foundation
import WeatherCore

final class DescriptionViewModel {
  
  private var forecast: Forecast?
  
  private init() {}
  
  init(forecast: Forecast) {
    self.forecast = forecast
  }
  
  var pressure: String {
    get {
      guard let pressure = self.forecast?.pressure else {
        return ""
      }
      return "\(L10n.pressure): \(pressure)"
    }
  }
  
  var rain: String {
    get {
      guard let rain = self.forecast?.rain else {
        return ""
      }
      return "\(L10n.rain): \(rain)"
    }
  }
  
  var snowRisk: String {
    get {
      guard let snowRisk = self.forecast?.snowRisk else {
        return ""
      }
      return "\(L10n.snowRisk): \(snowRisk)"
    }
  }
}
