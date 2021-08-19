//
//  CatalogRequestFactory.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 19.08.2021.
//

import Alamofire

protocol CatalogRequestFactory {
    
    func getGoods(page: Int,
                  category: Int,
                  completionHandler: @escaping (AFDataResponse<CatalogResult>) -> Void)
    
    func getGood(by id: Int,
                 completionHandler: @escaping (AFDataResponse<ProductByIdResult>) -> Void)
}
