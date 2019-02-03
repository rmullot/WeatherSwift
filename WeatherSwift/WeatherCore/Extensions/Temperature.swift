//
//  Temperature.swift
//  WeatherCore
//
//  Created by Romain Mullot on 02/02/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import Foundation

extension Float {

  /// convert Kelvin temperature in Celsius temperature
  /// - Returns: A float value coresponding to a celsius temperature
  public func convertKelvinInCelsius() -> Float {
    return  self - 273.15
  }

}

extension Double {

  /// convert Kelvin temperature in Celsius temperature
  /// - Returns: A float value coresponding to a celsius temperature
  public func convertKelvinInCelsius() -> Double {
    return  self - 273.15
  }

}
