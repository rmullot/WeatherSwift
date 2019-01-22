//
//  DiagnosticUITests.swift
//  DiagnosticUITests
//
//  Created by Romain Mullot on 08/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import XCTest

class SignInViewModelUITests: XCTestCase {

    private var app: XCUIApplication!
    private var tableView: XCUIElement!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test.
        // Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation
        // - required for your tests before they run. The setUp method is a good place to do this.
        XCUIApplication.accessibilityActivate()

        app = XCUIApplication()

        XCTAssertTrue(app.tables[UITestingIdentifiers.weatherTableViewController.rawValue].exists)
        tableView = app.tables[UITestingIdentifiers.weatherTableViewController.rawValue]
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_weather_row_event() {
      let predicate = NSPredicate(format: "count > 0")
      expectation(for: predicate, evaluatedWith: tableView.cells, handler: nil)

      waitForExpectations(timeout: 3, handler: nil)
      let firstCell = tableView.cells.element(boundBy: 0)
      firstCell.tap()
      let descriptionView = app.otherElements[UITestingIdentifiers.descriptionViewController.rawValue]
      XCTAssertTrue(descriptionView.exists)
    }
}
