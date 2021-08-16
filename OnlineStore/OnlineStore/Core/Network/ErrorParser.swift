//
//  ErrorParser.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 15.08.2021.
//

import Foundation

class ErrorParser: AbstractErrorParser {
    
    func parse(_ result: Error) -> Error {
        return result
    }
    
    func parse(response: HTTPURLResponse?,
               data: Data?,
               error: Error?) -> Error? {
        return error
    }
}
