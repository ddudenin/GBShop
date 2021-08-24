//
//  Product.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 19.08.2021.
//

import Foundation

struct Product: Codable {
    let id: Int
    let name: String
    let price: Int
}

typealias CatalogResult = [Product]

