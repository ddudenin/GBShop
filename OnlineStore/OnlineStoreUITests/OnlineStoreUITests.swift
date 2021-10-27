//
//  OnlineStoreUITests.swift
//  OnlineStoreUITests
//
//  Created by Дмитрий Дуденин on 04.08.2021.
//

import XCTest

class OnlineStoreUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSuccessLogin() throws {
        let app = XCUIApplication()
        app.launch()
        
        let loginTextField = app.textFields["sign in login"]
        loginTextField.tap()
        loginTextField.typeText("Somebody")
        
        let passwordSecureTextField = app.secureTextFields["sign in password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("mypassword")
        
        let signInButton = app.buttons["sign in"]
        signInButton.tap()
        
        XCTAssertTrue(app
                        .tabBars["Tab Bar"]
                        .buttons["Basket"]
                        .waitForExistence(timeout: 3.0))
    }
    
    func testFailureLogin() throws {
        let app = XCUIApplication()
        app.launch()
        
        let loginTextField = app.textFields["sign in login"]
        loginTextField.tap()
        loginTextField.typeText("Somebody")
        
        let passwordSecureTextField = app.secureTextFields["sign in password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("mypassword1")
        
        let signInButton = app.buttons["sign in"]
        signInButton.tap()
        
        app.alerts["Ошибка"].scrollViews.otherElements.buttons["OK"].tap()
        
        XCTAssertTrue(signInButton.waitForExistence(timeout: 3.0))
    }
    
    func testSuccessSignup() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.scrollViews.buttons["sign up"].tap()
        
        let loginTextField = app.textFields["user name"]
        tapElementAndWaitForKeyboardToAppear(element: loginTextField)
        loginTextField.typeText("Kipelov")
        app.keyboards.buttons["Done"].tap()
        
        let passwordSecureTextField = app.secureTextFields["sign up password"]
        tapElementAndWaitForKeyboardToAppear(element: passwordSecureTextField)
        passwordSecureTextField.typeText("Sw!ft1109")
        
        let emailTextField = app.textFields["email"]
        tapElementAndWaitForKeyboardToAppear(element: emailTextField)
        emailTextField.typeText("FireCurve@october.ru")
        app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards",".buttons[\"done\"]",".buttons[\"Done\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.buttons["register"].tap()
        
        XCTAssertTrue(app
                        .staticTexts["Online Store"]
                        .waitForExistence(timeout: 3.0))
    }
}

extension XCTestCase {
    
    func tapElementAndWaitForKeyboardToAppear(element: XCUIElement) {
        let keyboard = XCUIApplication().keyboards.element
        while (true) {
            element.tap()
            if keyboard.exists {
                break
            }
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.5))
        }
    }
}
