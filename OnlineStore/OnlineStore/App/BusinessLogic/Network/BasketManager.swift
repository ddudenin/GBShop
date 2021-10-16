//
//  BasketManager.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 18.09.2021.
//

import Alamofire

class BasketManager: AbstractRequestFactory {
    
    let errorParser: AbstractErrorParser
    let sessionManager: Session
    let queue: DispatchQueue
    private let baseUrl = URL(string: "https://cryptic-citadel-85782.herokuapp.com/")!
    
    init(
        errorParser: AbstractErrorParser,
        sessionManager: Session,
        queue: DispatchQueue = DispatchQueue.global(qos: .utility)) {
            self.errorParser = errorParser
            self.sessionManager = sessionManager
            self.queue = queue
        }
}

extension BasketManager: BasketRequestFactory {
    
    func addToBasket(productId: Int,
                     quantity: Int,
                     completionHandler: @escaping (AFDataResponse<RequestResult>) -> Void) {
        let requestModel = AddingBasket(baseUrl: baseUrl,
                                        productId: productId,
                                        quantity: quantity)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func removeFromBasket(productId: Int, completionHandler: @escaping (AFDataResponse<RequestResult>) -> Void) {
        let requestModel = RemovingBasket(baseUrl: baseUrl,
                                          productId: productId)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func payBasket(userId: Int,
                   basketCost: Int,
                   userBalance: Int,
                   completionHandler: @escaping (AFDataResponse<ResultWithMessage>) -> Void) {
        let requestModel = PayingBasket(baseUrl: baseUrl,
                                        userId: userId,
                                        basketCost: basketCost,
                                        userBalance: userBalance)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
}

extension BasketManager {
    
    struct AddingBasket: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "addToBasket"
        
        let productId: Int
        let quantity: Int
        
        var parameters: Parameters? {
            return [
                "productId": productId,
                "quantity": quantity
            ]
        }
    }
    
    struct RemovingBasket: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "removeFromBasket"
        
        let productId: Int
        
        var parameters: Parameters? {
            return [
                "productId": productId,
            ]
        }
    }
    
    struct PayingBasket: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "payBasket"
        
        let userId: Int
        let basketCost: Int
        let userBalance: Int
        
        var parameters: Parameters? {
            return [
                "userId": userId,
                "basketCost": basketCost,
                "userBalance": userBalance
            ]
        }
    }
}
