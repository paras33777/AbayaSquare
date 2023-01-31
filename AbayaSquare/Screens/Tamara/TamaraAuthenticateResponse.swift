//
//  TamaraAuthenticateResponse.swift
//  AbayaSquare
//
//  Created by Pratibha on 22/09/22.
//

import Foundation

struct TamaraAuthenticateResponse: Codable {
    var token: String
    var expiredAt: String?
    
    enum CodingKeys: String, CodingKey {
        case token
        case expiredAt = "expired_at"
    }
}
