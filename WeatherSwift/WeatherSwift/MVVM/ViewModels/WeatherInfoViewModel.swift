//
//  WeatherInfoViewModel.swift
//  WeatherSwift
//
//  Created by Romain Mullot on 22/01/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import Foundation
import WeatherCore

final class WeatherInfoViewModel {
    
    private var forecasts: [Forecast]?
    
    var forecastsDidChange: ((WeatherInfoViewModel) -> ())?
    
    var forecastsCount : Int {
        return forecasts?.count ?? 0
    }
    
    func getForecastViewModel(index: Int) -> ForecastViewModel? {
        guard let forecasts = forecasts, forecasts.count > 0, index < forecasts.count, index >= 0   else { return nil }
        return ForecastViewModel(forecast:forecasts[index])
    }
    
    func updateForecasts() {
      BridgeForecastService.getForecasts(completionHandler: { (forecasts) in
            self.forecasts = forecasts
            self.forecastsDidChange?(self)
        })
    }
  
  func displayDescription(index: Int) {
    guard let forecasts = forecasts, forecasts.count > 0, index < forecasts.count, index >= 0   else { return }
    NavigationService.sharedInstance.navigateToDescription(forecast: forecasts[index])
  }
}
