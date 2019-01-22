//
//  ForecastViewModelTest.swift
//  WeatherSwiftTests
//
//  Created by Romain Mullot on 22/01/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import XCTest
@testable import WeatherSwift
@testable import WeatherCore

class ForecastViewModelTest: MockEnvironmentTest {

    private var viewModelValid: ForecastViewModel!
    private var viewModelInvalid: ForecastViewModel!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let forecast = Forecast(context: managedObjectContext)
        forecast.temperature = 300
        forecast.date = NSDate()
        viewModelValid = ForecastViewModel(forecast: forecast)

        let forecastInvalid = Forecast(context: managedObjectContext)
        forecastInvalid.temperature = 263.15
        forecastInvalid.date = NSDate(timeIntervalSince1970: 1030300)
        viewModelInvalid = ForecastViewModel(forecast: forecastInvalid)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_date_Valid_Today() {
        XCTAssertTrue(viewModelValid.date.contains("Aujourd'hui à "))
    }
    func test_date_Valid_AnotherDay() {
        XCTAssertEqual("lundi 12 janvier 1970 à 23:11", viewModelInvalid.date)
    }

    func test_weatherDescription_Valid() {
        XCTAssertEqual("26.85˚ Celsius", viewModelValid.weatherDescription)
    }

    func test_weatherDescription_Invalid() {
        XCTAssertEqual("-10.00˚ Celsius", viewModelInvalid.weatherDescription)
    }

}
