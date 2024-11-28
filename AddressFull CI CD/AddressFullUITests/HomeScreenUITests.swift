//
//  Untitled.swift
//  AddressFull
//
//  Created by Sneh on 26/11/24.
//

import XCTest

final class HomeScreenUITests : XCTestCase {
    
    func testHomeScreen() {
        
        let app = XCUIApplication()
        app.tables.cells.containing(.staticText, identifier:"Secure Hub UK Ltd").buttons["more vertical"].tap()
        app.buttons["View shared details"].tap()
        
        let crossButton = app.buttons["cross"]
        crossButton.tap()
        crossButton.tap()                   
              
    }
}
