//
//  LoginResult.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 15.08.2021.
//

import Foundation

struct LoginResult: Codable {
    let result: Int
    let user: User
}
