//
//  TamaraCheckoutSuccess.swift
//  AbayaSquare
//
//  Created by Pratibha on 22/09/22.
//

import Foundation

public struct TamaraCheckoutSuccess: Codable {
    var orderId: String?
    var checkoutUrl: String = ""
    
    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
        case checkoutUrl = "checkout_url"
    }
    
    init() {
        
    }
}
