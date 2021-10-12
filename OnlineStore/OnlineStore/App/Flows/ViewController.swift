//
//  ViewController.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 04.08.2021.
//

import UIKit

class ViewController: UIViewController {
    
    let requestFactory = RequestFactory.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //signup()
        //login()
        //logout()
        //changeUserData()
        
        //getCategoryProducts()
        //getProductById()
        
        //addReview()
        //removeReview()
        //getProductReviews()
        
        addToBasket()
        removeFromBasket()
        payBasket()
    }
    
    func login() {
        let auth = requestFactory.makeAuthRequestFactory()
        auth.login(userName: "Somebody", password: "mypassword") { response in
            switch response.result {
            case .success(let login):
                log(message: "\(login)", .Success)
            case .failure(let error):
                log(message: error.localizedDescription, .Error)
            }
        }
    }
    
    func logout() {
        let auth = requestFactory.makeAuthRequestFactory()
        auth.logout(userId: 123) { response in
            switch response.result {
            case .success(let logout):
                log(message: "\(logout)", .Success)
            case .failure(let error):
                log(message: error.localizedDescription, .Error)
            }
        }
    }
    
    func signup() {
        let auth = requestFactory.makeAuthRequestFactory()
        let data = UserData(id: 123,
                            username: "Somebody",
                            password: "mypassword",
                            email: "some@some.ru",
                            gender: "m",
                            card: "9872389-2424-234224-234",
                            bio: "This is good! I think I will switch to another language")
        auth.signup(data: data) { response in
            switch response.result {
            case .success(let signup):
                log(message: "\(signup)", .Success)
            case .failure(let error):
                log(message: error.localizedDescription, .Error)
            }
        }
    }
    
    func changeUserData() {
        let auth = requestFactory.makeAuthRequestFactory()
        let data = UserData(id: 123,
                            username: "Somebody",
                            password: "mypassword",
                            email: "some@some.ru",
                            gender: "m",
                            card: "9872389-2424-234224-234",
                            bio: "This is good! I think I will switch to another language")
        auth.changeUserData(data: data) { response in
            switch response.result {
            case .success(let changedData):
                log(message: "\(changedData)", .Success)
            case .failure(let error):
                log(message: error.localizedDescription, .Error)
            }
        }
    }
    
    func getCategoryProducts() {
        let catalog = requestFactory.makeCatalogRequestFactory()
        catalog.getProducts(page: 1, category: 1) { response in
            switch response.result {
            case .success(let products):
                log(message: "\(products)", .Success)
            case .failure(let error):
                log(message: error.localizedDescription, .Error)
            }
        }
    }
    
    func getProductById() {
        let catalog = requestFactory.makeCatalogRequestFactory()
        catalog.getProduct(by: 123) { response in
            switch response.result {
            case .success(let product):
                log(message: "\(product)", .Success)
            case .failure(let error):
                log(message: error.localizedDescription, .Error)
            }
        }
    }
    
    func addReview() {
        let review = requestFactory.makeReviewRequestFactory()
        review.addReview(userId: 123,
                         reviewText: "Текст отзыва") { response in
            switch response.result {
            case .success(let newReview):
                log(message: "\(newReview)", .Success)
            case .failure(let error):
                log(message: error.localizedDescription, .Error)
            }
        }
    }
    
    func removeReview() {
        let review = requestFactory.makeReviewRequestFactory()
        review.removeReview(withId: 123) { response in
            switch response.result {
            case .success(let deletedReview):
                log(message: "\(deletedReview)", .Success)
            case .failure(let error):
                log(message: error.localizedDescription, .Error)
            }
        }
    }
    
    func getProductReviews() {
        let review = requestFactory.makeReviewRequestFactory()
        review.getReviewsForProduct(withId: 2707) { response in
            switch response.result {
            case .success(let reviews):
                log(message: "\(reviews)", .Success)
            case .failure(let error):
                log(message: error.localizedDescription, .Error)
            }
        }
    }
    
    func addToBasket() {
        let basket = requestFactory.makeBasketRequestFactory()
        basket.addToBasket(productId: 123, quantity: 1) { response in
            switch response.result {
            case .success(let result):
                log(message: "\(result)", .Success)
            case .failure(let error):
                log(message: error.localizedDescription, .Error)
            }
        }
    }
    
    func removeFromBasket() {
        let basket = requestFactory.makeBasketRequestFactory()
        basket.removeFromBasket(productId: 123) { response in
            switch response.result {
            case .success(let result):
                log(message: "\(result)", .Success)
            case .failure(let error):
                log(message: error.localizedDescription, .Error)
            }
        }
    }
    
    func payBasket() {
        let basket = requestFactory.makeBasketRequestFactory()
        basket.payBasket(userId: 123, payAmount: 270000) { response in
            switch response.result {
            case .success(let result):
                log(message: "\(result)", .Success)
            case .failure(let error):
                log(message: error.localizedDescription, .Error)
            }
        }
    }
}
