//
//  ViewController.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 04.08.2021.
//

import UIKit

class ViewController: UIViewController {

    let requestFactory = RequestFactory()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        signup()
        login()
        logout()
        changeUserData()

        getCategoryProducts()
        getProductById()
    }

    func login() {
        let auth = requestFactory.makeAuthRequestFatory()
        auth.login(userName: "Somebody", password: "mypassword") { response in
            switch response.result {
            case .success(let login):
                Logger.instance.logMessage(message: "\(login)", .Success)
            case .failure(let error):
                Logger.instance.logMessage(message: error.localizedDescription, .Error)
            }
        }
    }

    func logout() {
        let auth = requestFactory.makeAuthRequestFatory()
        auth.logout(userId: 123) { response in
            switch response.result {
            case .success(let login):
                Logger.instance.logMessage(message: "\(login)", .Success)
            case .failure(let error):
                Logger.instance.logMessage(message: error.localizedDescription, .Error)
            }
        }
    }

    func signup() {
        let auth = requestFactory.makeAuthRequestFatory()
        let data = UserData(id: 123,
                            username: "Somebody",
                            password: "mypassword",
                            email: "some@some.ru",
                            gender: "m",
                            card: "9872389-2424-234224-234",
                            bio: "This is good! I think I will switch to another language")
        auth.signup(data: data) { response in
            switch response.result {
            case .success(let login):
                Logger.instance.logMessage(message: "\(login)", .Success)
            case .failure(let error):
                Logger.instance.logMessage(message: error.localizedDescription, .Error)
            }
        }
    }

    func changeUserData() {
        let auth = requestFactory.makeAuthRequestFatory()
        let data = UserData(id: 123,
                            username: "Somebody",
                            password: "mypassword",
                            email: "some@some.ru",
                            gender: "m",
                            card: "9872389-2424-234224-234",
                            bio: "This is good! I think I will switch to another language")
        auth.changeUserData(data: data) { response in
            switch response.result {
            case .success(let login):
                Logger.instance.logMessage(message: "\(login)", .Success)
            case .failure(let error):
                Logger.instance.logMessage(message: error.localizedDescription, .Error)
            }
        }
    }

    func getCategoryProducts() {
        let catalog = requestFactory.makeCatalogRequestFatory()
        catalog.getProducts(page: 1, category: 1) { response in
            switch response.result {
            case .success(let login):
                Logger.instance.logMessage(message: "\(login)", .Success)
            case .failure(let error):
                Logger.instance.logMessage(message: error.localizedDescription, .Error)
            }
        }
    }

    func getProductById() {
        let catalog = requestFactory.makeCatalogRequestFatory()
        catalog.getProduct(by: 123) { response in
            switch response.result {
            case .success(let login):
                Logger.instance.logMessage(message: "\(login)", .Success)
            case .failure(let error):
                Logger.instance.logMessage(message: error.localizedDescription, .Error)
            }
        }
    }
}
