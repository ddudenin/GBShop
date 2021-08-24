//
//  Catalog.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 19.08.2021.
//

import Alamofire

class Catalog: AbstractRequestFactory {
    
    let errorParser: AbstractErrorParser
    let sessionManager: Session
    let queue: DispatchQueue
    let baseUrl = URL(string: "http://127.0.0.1:8080/")!
    
    init(
        errorParser: AbstractErrorParser,
        sessionManager: Session,
        queue: DispatchQueue = DispatchQueue.global(qos: .utility)) {
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
}

extension Catalog: CatalogRequestFactory {
    
    func getProducts(page: Int,
                     category: Int,
                     completionHandler: @escaping (AFDataResponse<CatalogResult>) -> Void) {
        let requestModel = Page(baseUrl: baseUrl,
                                page: page,
                                category: category)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func getProduct(by id: Int,
                    completionHandler: @escaping (AFDataResponse<ProductByIdResult>) -> Void) {
        let requestModel = Good(baseUrl: baseUrl, id: id)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
}

extension Catalog {
    
    struct Page: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "catalogData"
        
        let page: Int
        let category: Int
        var parameters: Parameters? {
            return [
                "pageNumber": page,
                "idCategory": category
            ]
        }
    }
    
    struct Good: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "getProductById"
        
        let id: Int
        var parameters: Parameters? {
            return [
                "idProduct": id
            ]
        }
    }
}
