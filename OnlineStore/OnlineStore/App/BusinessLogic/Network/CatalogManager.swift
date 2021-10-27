//
//  Catalog.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 19.08.2021.
//

import Alamofire

class CatalogManager: AbstractRequestFactory {

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

extension CatalogManager: CatalogRequestFactory {

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
        let requestModel = Product(baseUrl: baseUrl, id: id)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
}

extension CatalogManager {

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

    struct Product: RequestRouter {
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
