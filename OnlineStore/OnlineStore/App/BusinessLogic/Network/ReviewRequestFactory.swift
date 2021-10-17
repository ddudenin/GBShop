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
                   completionHandler: @escaping (AFDataResponse<ResultWithMessage>) -> Void)

    func removeReview(withId: Int,
                      completionHandler: @escaping (AFDataResponse<RequestResult>) -> Void)

    func getReviewsForProduct(withId: Int,
                              completionHandler: @escaping (AFDataResponse<ProductReviewsResult>) -> Void)
}
