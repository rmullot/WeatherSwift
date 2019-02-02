//
//  DescriptionViewModel.swift
//  WeatherSwift
//
//  Created by Romain Mullot on 02/02/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import Foundation
import WeatherCore

final class DescriptionViewModel: BaseViewModel {

  private var forecast: Forecast?

  internal required init() {}

  init(forecast: Forecast) {
    self.forecast = forecast
  }

  var pressure: String {
    guard let pressure = self.forecast?.pressure else {
      return ""
    }
    return "\(L10n.pressure): \(pressure)"
  }

  var rain: String {
    guard let rain = self.forecast?.rain else {
      return ""
    }
    return "\(L10n.rain): \(rain)"
  }

  var snowRisk: String {
    guard let snowRisk = self.forecast?.snowRisk else {
      return ""
    }
    return "\(L10n.snowRisk): \(snowRisk)"
  }
}
