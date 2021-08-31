//
//  Review.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 31.08.2021.
//

import Alamofire

class Review: AbstractRequestFactory {
    
    let errorParser: AbstractErrorParser
    let sessionManager: Session
    let queue: DispatchQueue
    let baseUrl = URL(string: "https://cryptic-citadel-85782.herokuapp.com/")!
    
    init(
        errorParser: AbstractErrorParser,
        sessionManager: Session,
        queue: DispatchQueue = DispatchQueue.global(qos: .utility)) {
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
}

extension Review: ReviewRequestFactory {
    
    func addReview(userId: Int,
                   reviewText: String,
                   completionHandler: @escaping (AFDataResponse<AddReviewResult>) -> Void) {
        let requestModel = NewReview(baseUrl: baseUrl,
                                     userId: userId,
                                     reviewText: reviewText)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func removeReview(withId id: Int,
                      completionHandler: @escaping (AFDataResponse<RemoveReviewResult>) -> Void) {
        let requestModel = RemovingReview(baseUrl: baseUrl, commentId: id)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
}

extension Review {
    
    struct NewReview: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "addReview"
        
        let userId: Int
        let reviewText: String
        var parameters: Parameters? {
            return [
                "userId": userId,
                "reviewText": reviewText
            ]
        }
    }
    
    struct RemovingReview: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "removeReview"
        
        let commentId: Int
        var parameters: Parameters? {
            return [
                "commentId": commentId
            ]
        }
    }
}
