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
    let baseUrl = URL(string: "https://raw.githubusercontent.com/GeekBrainsTutorial/online-store-api/master/responses/")!
    
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
    
    func getGoods(page: Int,
                  category: Int,
                  completionHandler: @escaping (AFDataResponse<CatalogResult>) -> Void) {
        let requestModel = Page(baseUrl: baseUrl,
                                page: page,
                                category: category)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func getGood(by id: Int,
                 completionHandler: @escaping (AFDataResponse<ProductByIdResult>) -> Void) {
        let requestModel = Good(baseUrl: baseUrl, id: id)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
}

extension Catalog {
    
    struct Page: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "catalogData.json"
        
        let page: Int
        let category: Int
        var parameters: Parameters? {
            return [
                "page_number": page,
                "id_category": category
            ]
        }
    }
    
    struct Good: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "getGoodById.json"
        
        let id: Int
        var parameters: Parameters? {
            return [
                "id_product": id
            ]
        }
    }
}
