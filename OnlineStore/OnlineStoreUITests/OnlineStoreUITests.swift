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
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSuccessLogin() throws {
        let app = XCUIApplication()
        app.launch()
        
        let scrollViewQuery = app.scrollViews
        
        let loginTextField = scrollViewQuery
            .otherElements
            .textFields["Enter your login"]
        loginTextField.tap()
        loginTextField.typeText("Somebody")
        
        let passwordSecureTextField = scrollViewQuery
            .otherElements
            .secureTextFields["Enter your password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("mypassword")
        
        let signinButton = scrollViewQuery
            .otherElements
        /*@START_MENU_TOKEN@*/.staticTexts["Sign in"]/*[[".buttons[\"Sign in\"].staticTexts[\"Sign in\"]",".staticTexts[\"Sign in\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        signinButton.tap()
        
        XCTAssertTrue(app
                        .tabBars["Tab Bar"]
                        .buttons["Basket"]
                        .waitForExistence(timeout: 3.0))
    }
    
    func testFailureLogin() throws {
        let app = XCUIApplication()
        app.launch()
        
        let scrollViewQuery = app.scrollViews
        
        let loginTextField = scrollViewQuery
            .otherElements
            .textFields["Enter your login"]
        loginTextField.tap()
        loginTextField.typeText("Somebody")
        
        let passwordSecureTextField = scrollViewQuery
            .otherElements
            .secureTextFields["Enter your password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("mypassword1")
        
        let signinButton = scrollViewQuery
            .otherElements
        /*@START_MENU_TOKEN@*/.staticTexts["Sign in"]/*[[".buttons[\"Sign in\"].staticTexts[\"Sign in\"]",".staticTexts[\"Sign in\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        signinButton.tap()
        
        app.alerts["Ошибка"].scrollViews.otherElements.buttons["OK"].tap()
    }
    
    func testSuccessSignup() throws {
        let app = XCUIApplication()
        app.launch()
        
        let scrollViewsQuery = app.scrollViews
 
        let elementsQuery = scrollViewsQuery.otherElements
        
        elementsQuery.buttons["person.crop.square.filled.and.at.rectangle"].tap()
        
        let returnButton = app.buttons["Return"]
        
        let loginTextField = app.textFields["user name"]
        loginTextField.tap()
        loginTextField.tap()
        loginTextField.typeText("Kipelov")
        returnButton.tap()
        
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.typeText("Sw!ft1109")
        returnButton.tap()
        
        let emailTextField = app.textFields["email"]
        emailTextField.typeText("FireCurve@october.ru")
        returnButton.tap()
        
        
        let creditCardNumberTextField = app.textFields["credit card number"]
        creditCardNumberTextField.typeText("1234-5678-1357-2468")
        returnButton.tap()

        let bioTextField = app.textFields["bio"]
        bioTextField.typeText("Release")
        returnButton.tap()
        
        app.buttons["person.fill.checkmark"].tap()
        
        XCTAssertTrue(elementsQuery
                        .staticTexts["Online Store"]
                        .waitForExistence(timeout: 3.0))
    }
}
