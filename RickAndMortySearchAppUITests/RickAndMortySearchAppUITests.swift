//
//  RickAndMortySearchAppUITests.swift
//  RickAndMortySearchAppUITests
//
//  Created by Suraj Raju Dhopati on 2/11/25.
//

import XCTest

final class RickAndMortySearchAppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {

    }

    func testSearchForRick() {
        let app = XCUIApplication()
        app.launch()
        
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 5), "Search field should exist")
        
        searchField.tap()
        searchField.typeText("Rick")
        
        let rickCell = app.staticTexts["Rick Sanchez"]
        XCTAssertTrue(rickCell.waitForExistence(timeout: 5), "Expected to find 'Rick Sanchez' in search results")
    }
    
    func testToggleViewModeAndFindGridCell() {
        let app = XCUIApplication()
        app.launch()
        
        let toggleButton = app.buttons["Toggle Grid View"]
        XCTAssertTrue(toggleButton.waitForExistence(timeout: 5), "Toggle Grid View button should exist")
        toggleButton.tap()
        
        sleep(1)
        
        let gridCell = app.descendants(matching: .any).matching(identifier: "GridCell").firstMatch
        XCTAssertTrue(gridCell.waitForExistence(timeout: 5), "Expected at least one grid cell to appear")
    }

    func testLaunchPerformance() throws {
        if #available(iOS 13.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
