//
//  TamaraCheckoutError.swift
//  AbayaSquare
//
//  Created by Pratibha on 22/09/22.
//

import Foundation

public struct TamaraCheckoutError: Codable {
    var message: String?
    var errors: [TamaraMassageError]?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case errors = "errors"
    }
    init(){}
}

struct TamaraMassageError: Codable {
    var error_code: String?
    
    enum CodingKeys: String, CodingKey {
        case error_code = "error_code"
    }
}
