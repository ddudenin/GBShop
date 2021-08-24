//
//  ProductByIdResult.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 19.08.2021.
//

import Foundation

class ProductByIdResult: Codable {
    let result: Int
    let productName: String?
    let productPrice: Int?
    let productDescription: String?
}

