//
//  Review.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 04.09.2021.
//

import Foundation

struct Review: Codable {
    let id: Int
    let userId: Int?
    let text: String
}
