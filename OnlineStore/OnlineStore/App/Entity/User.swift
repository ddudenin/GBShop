//
//  User.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 15.08.2021.
//

import Foundation

struct User: Codable {
    let id: Int
    let login: String
    let firstname: String
    let lastname: String
}
