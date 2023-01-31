//
//  OrderModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/7/21.
//

import Foundation

enum OrdersModel {
    struct Request: Codable {
    }
    
    struct GetOrderDetails: Codable {
        let orderId: Int?
    }
    
    struct Response: GenericResponse {
        var status: Bool?
        var responseMessage: String?
        var errors: [ResponseError]?
        let orders: [Order]?
    }
    
    struct  GetOrderDetailsResponse: GenericResponse {
        var status: Bool?
        var responseMessage: String?
        var errors: [ResponseError]?
        let order: Order?
    }
    
    struct CancelOrder: Codable {
        let orderId: Int?
    }
    
    struct ReturnProduct: Codable {
        let orderId: Int?
        let orderProductId: Int?
    }
}

struct Order: Codable {
    let id: Int?
    let invoiceNumber: String?
    let mobile: String?
    let createdAt: String?
    let status: Status?
    let statusLog: [StatusLog]?
    let customerId, addressId: Int?
    let subTotal1, discount, subTotal2, tax: Double?
    let deliveryCost,taxRatio: Double?
    let transactionId: String?
    let isPaid: Int?
    let useWallet: Int?
    let usedWalletAmount: Double?
    let codAmount: Double?
    let paymentType: Int?
    let total: Double?
    let cancelReason: String?
    let billFileName: String?
    let paymentTypeId: Int?
    let createdText, name: String?
    let invoiceUrl: String?
    let promoCode: String?
    let firstProductName: String?
    let productsCount : Int?
    let customer: User?
    let paymentId: String?
    let address: Address?
    let products: [OrderProduct]?
    let tabyPaymentRef: String?
}

struct OrderProduct: Codable{
    let id, qty: Int?
    let price: Double?
    let discountRatio: Int?
    let discount: Double?
    let total: Double?
    let orderId: Int?
    let size: Size?
    let store: Designer?
    let product: Product?
    let couponId: Offer?
}


struct StatusLog: Codable {
    var id: Int?
    var status: Status?
    var orderId: Int?
    var createdAt: String?
    var name: String?
    
    init (status: Status) {
        self.status = status
    }
}

struct Status: Codable{
    var id: Int?
    var name, details: String?

    init (id: Int,name: String) {
        self.id = id
        self.name = name
    }
}
