//
//  PaymentMethodModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/6/21.
//

import Foundation
enum PaymentMethodModel {
    
    struct Request: Codable {
    }
    
    struct Response: GenericResponse {
        var status: Bool?
        var responseMessage: String?
        var errors: [ResponseError]?
        let paymentTypes: [PaymentType]?
    }
}

enum AddOrderModel {
    struct Request: Codable {
        var promoCode: String? = nil
        var paymentTypeId: Int = 0
        var useWallet: Int = 0
        var addressId: Int = 0
        var applePayRefernce: String = ""
        var ref: String = ""
        var discount_amount: Int = 0
        var products: [PlaceOrderModel] = []
    }
    
    struct Response: GenericResponse {
        var status: Bool?
        var responseMessage: String?
        var errors: [ResponseError]?
        var order: AddOrderResponse?
    }
}

struct AddOrderResponse: Codable {
    let paymentTransactionUrl: String?
    let paymentId:String?
    let order: Order?
}

struct PaymentType: Codable {
    let id: Int
    let name: String?
    let iconUrl: String?
}

struct PlaceOrderModel: Codable {
    let productId: Int16
    let storeId: Int16
    var couponId: Int16
    let qty: Int16
    let sizeId: Int16
}

enum TabbyPaymentType {
    case Installments
    case PayLater
}

struct TabbyCheckoutRequestModel: Codable {
    let payment: TabbyPaymentModel
    let lang: String
    let merchantCode: String
}

struct TabbyPaymentModel: Codable {
    let amount: String?
    let currency: String?
    let description: String?
    let buyer: TabbyBuyerModel?
    let buyerHistory: TabbyBuyerHistory?
    let order: TabbyOrder?
    let orderHistory: [TabbyOrderHistory]?
    let shippingAddress: TabbyShippingAddress?
}

struct TabbyBuyerHistory: Codable {
    var registeredSince: String = "2019-08-24T14:15:22Z"
    var loyaltyLevel: Int = 10
    var wishlistCount: Int = 421
    var isSocialNetworksConnected: Bool = true
    var isPhoneNumberVerified: Bool = true
    var isEmailVerified:Bool = true
}

struct TabbyBuyerModel: Codable {
    let email: String?
    let phone: String?
    let name: String?
}

struct TabbyShippingAddress: Codable {
    let city: String?
    let address: String?
    var zip: String? = "123456"
}

struct TabbyOrder: Codable {
    let taxAmount: String?
    let shippingAmount: String?
    let discountAmount: String?
    let referenceId: String?
    let items: [TabbyOrderItems]?
}

struct TabbyOrderHistory: Codable {
    let amount: String?
    var paymentMethod: String? = "CoD"
    var status : String = "new"
    let items: [TabbyOrderItems]
}

struct TabbyOrderItems: Codable {
    let title,referenceId,unitPrice: String?
    let quantity: Int
}

struct TabbyCheckoutResponse: Codable {
    var status: String?
    var responseMessage: String?
    var errors: [ResponseError]?
    let id: String?
//    let warnings: [TabbyWarning]?
    let configuration: TabbyConfiguration?
    let apiURL: String?
    let token: String?
    let flow: String?
    let payment: TabbyPayment?
    //        let productType: JSONNull?
    let lang: String?
    //        let siftSessionID: JSONNull?
    //        let merchant: Merchant?
    let merchantCode: String?
    let termsAccepted: Bool?
    
}

struct TabbyConfiguration: Codable {
    let currency, appType: String?
    let newCustomer: Bool?
//    let availableLimit, minLimit: JSONNull?
    let availableProducts: TabbyAvailableProducts?
    let country: String?
    let expiresAt: String?
    let isBankCardRequired: Bool?
//    let blockedUntil: JSONNull?
//    let products: Products?
}

struct TabbyAvailableProducts: Codable {
    let installments, payLater: [TabbyInstallments]?
}

struct TabbyInstallments:Codable{
    let downpayment, downpaymentPercent, amountToPay: String?
    let nextPaymentDate: String?
    let payAfterDelivery: Bool?
    let payPerInstallment: String?
    let webUrl: String?
    let id, installmentsCount: Int?
    let installmentPeriod, serviceFee: String?
}

struct TabbyPayment: Codable {
    let createdAt : String?
    let id: String?
    let amount: String?
    let order: TabbyCaptureOrder?
}


struct TabbyCaptureOrder: Codable {
    let referenceId: String?
    let taxAmount, shippingAmount, discountAmount: String?
//    let items: [OrderItem]?
}
