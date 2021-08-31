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
    
    // MARK: Test Login
    
    func testSuccessLogin() throws {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let session = Session(configuration: configuration)
        
        let auth = Auth(errorParser: ErrorParser(),
                        sessionManager: session)
        
        let authExpectation = expectation(description: "Success Login")
        
        auth.login(userName: "Somebody",
                   password: "mypassword") { (response) in
            switch response.result {
            case .success(let model):
                XCTAssertEqual(model.result, 1)
                XCTAssertNotNil(model.user)
                XCTAssertEqual(model.user?.id, 123)
                XCTAssertEqual(model.user?.login, "geekbrains")
                XCTAssertEqual(model.user?.firstname, "John")
                XCTAssertEqual(model.user?.lastname, "Doe")
                XCTAssertEqual(model.authToken, "some_authorizaion_token")
                
                authExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [authExpectation], timeout: 5.0)
    }
    
    func testFailureLogin() throws {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let session = Session(configuration: configuration)
        
        let auth = Auth(errorParser: ErrorParser(),
                        sessionManager: session)
        
        let authExpectation = expectation(description: "Failure Login")
        
        auth.login(userName: "Somebody",
                   password: "wrongPassword") { (response) in
            switch response.result {
            case .success(let model):
                XCTAssertEqual(model.result, 0)
                XCTAssertNil(model.user)
                XCTAssertNil(model.authToken)
                
                authExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [authExpectation], timeout: 5.0)
    }
    
    // MARK: Test Logout
    
    func testSuccessLogout() {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let session = Session(configuration: configuration)
        
        let auth = Auth(errorParser: ErrorParser(),
                        sessionManager: session)
        
        let authExpectation = expectation(description: "Success Logout")
        
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
    
    func testFailureLogout() {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let session = Session(configuration: configuration)
        
        let auth = Auth(errorParser: ErrorParser(),
                        sessionManager: session)
        
        let authExpectation = expectation(description: "Failure Logout")
        
        auth.logout(userId: 321) { (response) in
            switch response.result {
            case .success(let model):
                XCTAssertEqual(model.result, 0)
                
                authExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [authExpectation], timeout: 5.0)
    }
    
    // MARK: Test Signup
    
    func testSuccessSignup() {
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
        
        let authExpectation = expectation(description: "Success Signup")
        
        auth.signup(data: data) { (response) in
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
    
    func testFailureSignup() {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let session = Session(configuration: configuration)
        
        let data = UserData(id: 456,
                            username: "wrongName",
                            password: "mypassword",
                            email: "some@some.ru",
                            gender: "m",
                            card: "9872389-2424-234224-234",
                            bio: "This is good! I think I will switch to another language")
        
        let auth = Auth(errorParser: ErrorParser(),
                        sessionManager: session)
        
        let authExpectation = expectation(description: "Failure Signup")
        
        auth.signup(data: data) { (response) in
            switch response.result {
            case .success(let model):
                XCTAssertEqual(model.result, 0)
                XCTAssertEqual(model.userMessage, "Сообщение об ошибке")
                
                authExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [authExpectation], timeout: 5.0)
    }
    
    // MARK: Test Change user data
    
    func testSuccessChangeUserData() {
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
        
        let authExpectation = expectation(description: "Success Change User Data")
        
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
    
    func testFailureChangeUserData() {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let session = Session(configuration: configuration)
        
        let data = UserData(id: 2707,
                            username: "Somebody",
                            password: "mypassword",
                            email: "some@some.ru",
                            gender: "m",
                            card: "9872389-2424-234224-234",
                            bio: "")
        
        let auth = Auth(errorParser: ErrorParser(),
                        sessionManager: session)
        
        let authExpectation = expectation(description: "Failure Change User Data")
        
        auth.changeUserData(data: data) { (response) in
            switch response.result {
            case .success(let model):
                XCTAssertEqual(model.result, 0)
                
                authExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [authExpectation], timeout: 5.0)
    }
    
    // MARK: Test Get products
    
    func testSuccessGetCategoryProducts() {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let session = Session(configuration: configuration)
        
        let catalog = Catalog(errorParser: ErrorParser(),
                              sessionManager: session)
        
        let catalogExpectation = expectation(description: "Success Get category products")
        
        catalog.getProducts(page: 1, category: 1) { (response) in
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
    
    func testFailureGetCategoryProducts() {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let session = Session(configuration: configuration)
        
        let catalog = Catalog(errorParser: ErrorParser(),
                              sessionManager: session)
        
        let catalogExpectation = expectation(description: "Failure Get category products")
        
        catalog.getProducts(page: 1, category: 9) { (response) in
            switch response.result {
            case .success(let model):
                XCTAssertEqual(model.count, 0)
                
                catalogExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [catalogExpectation], timeout: 5.0)
    }
    
    // MARK: Test Get product by id
    
    func testSuccessGetProductById() {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let session = Session(configuration: configuration)
        
        let catalog = Catalog(errorParser: ErrorParser(),
                              sessionManager: session)
        
        let catalogExpectation = expectation(description: "Success Get product by id")
        
        catalog.getProduct(by: 123) { (response) in
            switch response.result {
            case .success(let model):
                XCTAssertEqual(model.result, 1)
                XCTAssertNotNil(model.productInfo)
                XCTAssertEqual(model.productInfo?.name, "Ноутбук")
                XCTAssertEqual(model.productInfo?.price, 45600)
                XCTAssertEqual(model.productInfo?.description, "Мощный игровой ноутбук")
                
                catalogExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [catalogExpectation], timeout: 5.0)
    }
    
    func testFailureGetProductById() {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let session = Session(configuration: configuration)
        
        let catalog = Catalog(errorParser: ErrorParser(),
                              sessionManager: session)
        
        let catalogExpectation = expectation(description: "Failure Get product by id")
        
        catalog.getProduct(by: 1109) { (response) in
            switch response.result {
            case .success(let model):
                XCTAssertEqual(model.result, 0)
                XCTAssertNil(model.productInfo)
                
                catalogExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [catalogExpectation], timeout: 5.0)
    }
    
    // MARK: Test Add review
    
    func testSuccessAddReview() {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let session = Session(configuration: configuration)
        
        let review = Review(errorParser: ErrorParser(),
                            sessionManager: session)
        
        let reviewExpectation = expectation(description: "Success Add Review")
        
        review.addReview(userId: 123,
                         reviewText: "Текст отзыва") { (response) in
            switch response.result {
            case .success(let model):
                XCTAssertEqual(model.result, 1)
                XCTAssertEqual(model.userMessage, "Ваш отзыв был передан на модерацию")
                
                reviewExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [reviewExpectation], timeout: 5.0)
    }
    
    func testFailureAddReview() {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let session = Session(configuration: configuration)
        
        let review = Review(errorParser: ErrorParser(),
                            sessionManager: session)
        
        let reviewExpectation = expectation(description: "Failure Add Review")
        
        review.addReview(userId: 321,
                         reviewText: "Текст отзыва") { (response) in
            switch response.result {
            case .success(let model):
                XCTAssertEqual(model.result, 0)
                XCTAssertEqual(model.userMessage, "Сообщение об ошибке")
                
                reviewExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [reviewExpectation], timeout: 5.0)
    }
    
    // MARK: Test Remove review
    
    func testSuccessRemoveReview() {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let session = Session(configuration: configuration)
        
        let review = Review(errorParser: ErrorParser(),
                            sessionManager: session)
        
        let reviewExpectation = expectation(description: "Success Remove Review")
        
        review.removeReview(withId: 123) { (response) in
            switch response.result {
            case .success(let model):
                XCTAssertEqual(model.result, 1)
                
                reviewExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [reviewExpectation], timeout: 5.0)
    }
    
    func testFailureRemoveReview() {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let session = Session(configuration: configuration)
        
        let review = Review(errorParser: ErrorParser(),
                            sessionManager: session)
        
        let reviewExpectation = expectation(description: "Failure Remove Review")
        
        review.removeReview(withId: 321) { (response) in
            switch response.result {
            case .success(let model):
                XCTAssertEqual(model.result, 0)
                
                reviewExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [reviewExpectation], timeout: 5.0)
    }
}
