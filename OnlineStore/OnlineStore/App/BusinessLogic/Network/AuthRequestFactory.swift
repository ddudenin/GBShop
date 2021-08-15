//
//  AuthRequestFactory.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 15.08.2021.
//

import Alamofire

protocol AuthRequestFactory {
    
    func login(userName: String,
               password: String,
               completionHandler: @escaping (AFDataResponse<LoginResult>) -> Void)
    
    func logout(userId: Int,
                completionHandler: @escaping (AFDataResponse<LogoutResult>) -> Void)
    
    func signin(data: UserData,
                completionHandler: @escaping (AFDataResponse<SigninResult>) -> Void)
    
    func changeUserData(data: UserData,
                        completionHandler: @escaping (AFDataResponse<ChangeUserDataResult>) -> Void)
}

