//
//  DescriptionViewModelTest.swift
//  WeatherSwiftTests
//
//  Created by Romain Mullot on 02/02/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import XCTest
@testable import WeatherSwift
@testable import WeatherCore

class DescriptionViewModelTest: MockEnvironmentTest {

  private var viewModelValid: DescriptionViewModel!

  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    let forecast = Forecast(context: managedObjectContext)
    forecast.rain = 50.5
    forecast.pressure = 10444
    forecast.snow = 1.0
    forecast.date = NSDate().timeIntervalSince1970
    viewModelValid = DescriptionViewModel(forecast: forecast)
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func test_rain_description_Valid() {
    XCTAssertEqual(viewModelValid.rain, "\(L10n.rain): 50.5")
  }

  func test_pressure_description_Valid() {
    XCTAssertEqual(viewModelValid.pressure, "\(L10n.pressure): 10444.0")
  }

  func test_snowRisk_description_Valid() {
    XCTAssertEqual(viewModelValid.snowRisk, "\(L10n.snowRisk): 1.0")
  }

}
