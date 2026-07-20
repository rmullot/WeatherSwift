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

  var clouds: String {
    guard let clouds = self.forecast?.clouds, clouds > -1 else {
      return ""
    }
    return "\(L10n.clouds): \(clouds)"
  }

  var humidity: String {
    guard let humidity = self.forecast?.humidity, humidity > -1 else {
      return ""
    }
    return "\(L10n.humidity): \(humidity)"
  }

  var pressure: String {
    guard let pressure = self.forecast?.pressure, pressure > -1 else {
      return ""
    }
    return "\(L10n.pressure): \(pressure)"
  }

  var rain: String {
    guard let rain = self.forecast?.rain, rain > -1 else {
      return ""
    }
    return "\(L10n.rain): \(rain)"
  }

  var snowRisk: String {
    guard let snowRisk = self.forecast?.snow, snowRisk > -1 else {
      return ""
    }
    return "\(L10n.snowRisk): \(snowRisk)"
  }

  var weatherType: String {
    guard var temperature = self.forecast?.temperature else {
      return ""
    }
    temperature = temperature.convertKelvinInCelsius()
    guard temperature > 25 else {
      return temperature < 10 ? L10n.coldWeather : ""
    }
    return  L10n.hotWeather
  }
}
