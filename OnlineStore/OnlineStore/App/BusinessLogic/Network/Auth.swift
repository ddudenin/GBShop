//
//  Auth.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 15.08.2021.
//

import Alamofire

class Auth: AbstractRequestFactory {
    
    let errorParser: AbstractErrorParser
    let sessionManager: Session
    let queue: DispatchQueue
    let baseUrl = URL(string: "https://shielded-beach-25860.herokuapp.com/")!
    
    init(
        errorParser: AbstractErrorParser,
        sessionManager: Session,
        queue: DispatchQueue = DispatchQueue.global(qos: .utility)) {
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
}

extension Auth: AuthRequestFactory {
    
    func login(userName: String,
               password: String,
               completionHandler: @escaping (AFDataResponse<LoginResult>) -> Void) {
        let requestModel = Login(baseUrl: baseUrl,
                                 login: userName,
                                 password: password)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func logout(userId: Int,
                completionHandler: @escaping (AFDataResponse<LogoutResult>) -> Void) {
        let requestModel = Logout(baseUrl: baseUrl, id: userId)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func signup(data: UserData,
                completionHandler: @escaping (AFDataResponse<SignupResult>) -> Void) {
        let requestModel = Signup(baseUrl: baseUrl, data: data)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func changeUserData(data: UserData,
                        completionHandler: @escaping (AFDataResponse<ChangeUserDataResult>) -> Void) {
        let requestModel = ChangeUserData(baseUrl: baseUrl, data: data)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
}

extension Auth {
    
    struct Login: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "login"
        
        let login: String
        let password: String
        var parameters: Parameters? {
            return [
                "username": login,
                "password": password
            ]
        }
    }
    
    struct Logout: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "logout"
        
        let id: Int
        var parameters: Parameters? {
            return [
                "idUser": id
            ]
        }
    }
    
    struct Signup: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "registerUser"
        
        let data: UserData
        
        var parameters: Parameters? {
            return [
                "idUser" : data.id,
                "username" : data.username,
                "password" : data.password,
                "email" : data.email,
                "gender": data.gender,
                "creditCard" : data.card,
                "bio" : data.bio
            ]
        }
    }
    
    struct ChangeUserData: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "changeUserData"
        
        let data: UserData
        
        var parameters: Parameters? {
            return [
                "idUser" : data.id,
                "username" : data.username,
                "password" : data.password,
                "email" : data.email,
                "gender": data.gender,
                "creditCard" : data.card,
                "bio" : data.bio
            ]
        }
    }
}

