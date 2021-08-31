//
//  RequestFactory.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 15.08.2021.
//

import Alamofire

class RequestFactory {

    func makeErrorParser() -> AbstractErrorParser {
        return ErrorParser()
    }

    lazy var commonSession: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let manager = Session(configuration: configuration)
        return manager
    }()

    let sessionQueue = DispatchQueue.global(qos: .utility)

    func makeAuthRequestFactory() -> AuthRequestFactory {
        let errorParser = makeErrorParser()
        return Auth(errorParser: errorParser,
                    sessionManager: commonSession,
                    queue: sessionQueue)
    }

    func makeCatalogRequestFactory() -> CatalogRequestFactory {
        let errorParser = makeErrorParser()
        return Catalog(errorParser: errorParser,
                       sessionManager: commonSession,
                       queue: sessionQueue)
    }
    
    func makeReviewRequestFactory() -> ReviewRequestFactory {
        let errorParser = makeErrorParser()
        return Review(errorParser: errorParser,
                      sessionManager: commonSession,
                      queue: sessionQueue)
    }
}
