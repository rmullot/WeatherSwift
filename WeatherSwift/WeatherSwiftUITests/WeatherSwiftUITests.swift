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
    override func setUp() {
      // Put setup code here. This method is called before the invocation of each test method in the class.

      // In UI tests it is usually best to stop immediately when a failure occurs.
      continueAfterFailure = false
      // UI tests must launch the application that they test.
      // Doing this in setup will make sure it happens for each test method.

      app = XCUIApplication()
      // In UI tests it’s important to set the initial state - such as interface orientation
      // - required for your tests before they run. The setUp method is a good place to do this.
      app.accessibilityActivate()
      app.launch()
      // In case where the splashscreen is a problem
      sleep(1)

      addUIInterruptionMonitor(withDescription: "Authorisez-vous que cette application utilise vos coordonnées GPS?") { (alert) -> Bool in
        alert.buttons["Autoriser"].tap()
        return true
      }
      // To fire addUIInterruptionMonitor
      let normalized = app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
      normalized.tap()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_display_description_weather() {

      XCTAssertTrue(app.collectionViews[UITestingIdentifiers.weatherCollectionViewController.rawValue].exists)
      let collectionView = app.collectionViews[UITestingIdentifiers.weatherCollectionViewController.rawValue]

      let exists = NSPredicate(format: "self.count > 0")
      expectation (for: exists, evaluatedWith: collectionView.cells, handler: nil)
      waitForExpectations(timeout: 5, handler: { (_) in

      })
      collectionView.cells.element(boundBy: 0).tap()
      let descriptionView = self.app.otherElements[UITestingIdentifiers.descriptionViewController.rawValue]
      XCTAssertTrue(descriptionView.exists)
    }
}
