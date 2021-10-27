//
//  BasketRequestFactory.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 18.09.2021.
//

import Alamofire

protocol BasketRequestFactory {

    func addToBasket(productId: Int,
                     quantity: Int,
                     completionHandler: @escaping (AFDataResponse<RequestResult>) -> Void)

    func removeFromBasket(productId: Int,
                          completionHandler: @escaping (AFDataResponse<RequestResult>) -> Void)

    func payBasket(userId: Int,
                   basketCost: Int,
                   userBalance: Int,
                   completionHandler: @escaping (AFDataResponse<ResultWithMessage>) -> Void)
}
