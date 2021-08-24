//
//  OnlineStoreTests.swift
//  OnlineStoreTests
//
//  Created by Дмитрий Дуденин on 04.08.2021.
//

import Alamofire
import XCTest
@testable import OnlineStore

class OnlineStoreTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLogin() throws {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let session = Session(configuration: configuration)
        
        let auth = Auth(errorParser: ErrorParser(),
                        sessionManager: session)
        
        let authExpectation = expectation(description: "Login")
        
        auth.login(userName: "Somebody",
                   password: "mypassword") { (response) in
            switch response.result {
            case .success(let model):
                XCTAssertEqual(model.result, 1)
                XCTAssertEqual(model.user.id, 123)
                XCTAssertEqual(model.user.login, "geekbrains")
                XCTAssertEqual(model.user.name, "John")
                XCTAssertEqual(model.user.lastname, "Doe")
                
                authExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [authExpectation], timeout: 5.0)
    }
    
    func testLogout() {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let session = Session(configuration: configuration)
        
        let auth = Auth(errorParser: ErrorParser(),
                        sessionManager: session)
        
        let authExpectation = expectation(description: "Logout")
        
        auth.logout(userId: 123) { (response) in
            switch response.result {
            case .success(let model):
                XCTAssertEqual(model.result, 1)
                
                authExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [authExpectation], timeout: 5.0)
    }
    
    func testSignin() {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let session = Session(configuration: configuration)
        
        let data = UserData(id: 123,
                            username: "Somebody",
                            password: "mypassword",
                            email: "some@some.ru",
                            gender: "m",
                            card: "9872389-2424-234224-234",
                            bio: "This is good! I think I will switch to another language")
        
        let auth = Auth(errorParser: ErrorParser(),
                        sessionManager: session)
        
        let authExpectation = expectation(description: "Signin")
        
        auth.signin(data: data) { (response) in
            switch response.result {
            case .success(let model):
                XCTAssertEqual(model.result, 1)
                XCTAssertEqual(model.userMessage, "Регистрация прошла успешно!")
                
                authExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [authExpectation], timeout: 5.0)
    }
    
    func testChangeUserData() {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let session = Session(configuration: configuration)
        
        let data = UserData(id: 123,
                            username: "Somebody",
                            password: "mypassword",
                            email: "some@some.ru",
                            gender: "m",
                            card: "9872389-2424-234224-234",
                            bio: "This is good! I think I will switch to another language")
        
        let auth = Auth(errorParser: ErrorParser(),
                        sessionManager: session)
        
        let authExpectation = expectation(description: "Change User Data")
        
        auth.changeUserData(data: data) { (response) in
            switch response.result {
            case .success(let model):
                XCTAssertEqual(model.result, 1)
                
                authExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [authExpectation], timeout: 5.0)
    }
    
    func testGetCategoryGoods() {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let session = Session(configuration: configuration)
        
        let catalog = Catalog(errorParser: ErrorParser(),
                              sessionManager: session)
        
        let catalogExpectation = expectation(description: "Get category goods")
        
        catalog.getGoods(page: 1, category: 1) { (response) in
            switch response.result {
            case .success(let model):
                XCTAssertEqual(model.count, 2)
                
                catalogExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [catalogExpectation], timeout: 5.0)
    }
    
    func testGetGoodById() {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let session = Session(configuration: configuration)
        
        let catalog = Catalog(errorParser: ErrorParser(),
                              sessionManager: session)
        
        let catalogExpectation = expectation(description: "Get good by id")
        
        catalog.getGood(by: 123) { (response) in
            switch response.result {
            case .success(let model):
                XCTAssertEqual(model.result, 1)
                XCTAssertEqual(model.name, "Ноутбук")
                XCTAssertEqual(model.price, 45600)
                XCTAssertEqual(model.description, "Мощный игровой ноутбук")
                
                catalogExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [catalogExpectation], timeout: 5.0)
    }
}
