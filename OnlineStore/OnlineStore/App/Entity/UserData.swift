//
//  UserData.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 15.08.2021.
//

import Foundation

struct UserData: Codable {
    let id: Int
    let username: String
    let password: String
    let email: String
    let gender: String
    let card: String
    let bio: String
}
