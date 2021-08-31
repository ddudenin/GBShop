//
//  ReviewRequestFactory.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 31.08.2021.
//

import Alamofire

protocol ReviewRequestFactory {
    
    func addReview(userId: Int,
                   reviewText: String,
                   completionHandler: @escaping (AFDataResponse<AddReviewResult>) -> Void)
    
    func removeReview(withId: Int,
                      completionHandler: @escaping (AFDataResponse<RemoveReviewResult>) -> Void)
}
