//
//  AddressFullUITests.swift
//  AddressFullUITests
//
//  Created by Sneh on 26/11/24.
//

import XCTest

final class AddressFullUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLogin() {
        
        let app = XCUIApplication()
        app.collectionViews/*@START_MENU_TOKEN@*/.buttons["Log in"]/*[[".cells.buttons[\"Log in\"]",".buttons[\"Log in\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        let txtmobilenumberTextField = elementsQuery/*@START_MENU_TOKEN@*/.textFields["txtMobileNumber"]/*[[".textFields[\"Select Mobile number\"]",".textFields[\"txtMobileNumber\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        txtmobilenumberTextField.tap()
        txtmobilenumberTextField.tap()
        elementsQuery.buttons["Send SMS verification code"].tap()
        
        let element = scrollViewsQuery.otherElements.containing(.image, identifier:"app_logo_green").children(matching: .other).element
        element.children(matching: .textField).element(boundBy: 1).tap()
        element.children(matching: .textField).element(boundBy: 2).tap()
        element.children(matching: .textField).element(boundBy: 3).tap()
        app.alerts["“AddressFull” Would Like to Access Your Contacts"].scrollViews.otherElements.buttons["Continue"].tap()
        app.buttons["Allow Full Access"].tap()
    }
    
    func testCompleteProfile() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["First name"]/*[[".cells.textFields[\"First name\"]",".textFields[\"First name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Last name"]/*[[".cells.textFields[\"Last name\"]",".textFields[\"Last name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Email*"]/*[[".otherElements[\"Email*\"].staticTexts[\"Email*\"]",".staticTexts[\"Email*\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        tablesQuery.textFields["Email 1"].tap()
        tablesQuery.textFields["Address 1"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Save"]/*[[".cells.buttons[\"Save\"]",".buttons[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Okay"].tap()
    }
    

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
