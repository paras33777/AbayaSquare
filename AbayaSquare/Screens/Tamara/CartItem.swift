//
//  CartItem.swift
//  AbayaSquare
//
//  Created by Pratibha on 22/09/22.
//

import Foundation
import Foundation

struct CartItem: Identifiable {
    let id = UUID()
    var name: String
    var sku: String
    var price: Double
    var tax: Double
    var quantity: Int
    var total: Double {
        return price * Double(quantity)
    }
}
