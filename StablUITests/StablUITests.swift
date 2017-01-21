//
//  StablUITests.swift
//  StablUITests
//
//  Created by Mijin Cho on 02/01/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//

import XCTest

class StablUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        /*
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        */
        
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        /*
        snapshot("SelectTime")
        
        XCUIApplication().otherElements.containing(.navigationBar, identifier:"How much time do you have?").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element(boundBy: 3).tap()
        
        
        snapshot("SearchResults")
        XCUIApplication().tables.cells["We're Alive - A \"Zombie\" Story of Survival, WAYLAND PRODUCTIONS, 152 EPISODES"].buttons["btn show notes"].tap()
        
        snapshot("ShowNotes")*/
    
    }
    
}
