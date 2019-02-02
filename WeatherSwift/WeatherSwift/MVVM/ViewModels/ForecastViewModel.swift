//
//  ForecastViewModel.swift
//  WeatherSwift
//
//  Created by Romain Mullot on 02/02/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import Foundation
import WeatherCore

final class ForecastViewModel: BaseViewModel {

  private var forecast: Forecast?

  internal required init() {}

  init(forecast: Forecast) {
    self.forecast = forecast
  }

  var date: String {
    guard let date = self.forecast?.date else {
      return ""
    }
    return FormatterService.sharedInstance.nameForDate(date as Date)
  }

  var weatherDescription: String {
    guard let temperature = self.forecast?.temperature else {
      return ""
    }
    return String(format: "%.2f˚ Celsius", temperature.convertKelvinInCelsius())
  }

}
