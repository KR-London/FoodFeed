//
//  FoodFeedUITests.swift
//  FoodFeedUITests
//

import XCTest

class FoodFeedUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {

//        let app = XCUIApplication()
//        setupSnapshot(app)
//        app.launch()
//        snapshot("01SwipeScreen")
//        app.buttons["Reset Beta Test?"].tap()
//        app.swipeLeft()
//        snapshot("02ProfileScreen")
//        app.textFields["Write here."].tap()
//        app.buttons["Next "].tap()
//        snapshot("03FriendScreen")
//        app.buttons["Follow "].tap()
//        
//        app.swipeLeft()
//        app.swipeLeft()
//        snapshot("04ChatScreen")
//        app.textFields["What do you think?"].tap()
//        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
