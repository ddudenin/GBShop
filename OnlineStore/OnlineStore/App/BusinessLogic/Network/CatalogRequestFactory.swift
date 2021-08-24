//
//  CatalogRequestFactory.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 19.08.2021.
//

import Alamofire

protocol CatalogRequestFactory {
    
    func getProducts(page: Int,
                     category: Int,
                     completionHandler: @escaping (AFDataResponse<CatalogResult>) -> Void)
    
    func getProduct(by id: Int,
                    completionHandler: @escaping (AFDataResponse<ProductByIdResult>) -> Void)
}
