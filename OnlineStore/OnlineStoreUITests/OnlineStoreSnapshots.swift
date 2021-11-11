//
//  OnlineStoreSnapshots.swift
//  OnlineStoreUITests
//
//  Created by Дмитрий Дуденин on 27.10.2021.
//

import XCTest

class OnlineStoreSnapshots: XCTestCase {

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
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
        snapshot("LoginScreen")
        
        let loginTextField = app.textFields["sign in login"]
        loginTextField.tap()
        loginTextField.typeText("Somebody")
        
        let passwordSecureTextField = app.secureTextFields["sign in password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("mypassword")
        
        let signInButton = app.buttons["sign in"]
        signInButton.tap()
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Profile"].tap()
        
        snapshot("EditProfileScreen")
    }
}
