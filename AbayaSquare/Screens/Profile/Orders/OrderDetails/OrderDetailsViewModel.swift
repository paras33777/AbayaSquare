//
//  OrderDetailsViewModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/10/21.
//

import Foundation
class OrderDetailsViewModel {
    
    var orderId: Int?
    var products: [OrderProduct] = []
    var orderCases: [StatusLog] = []
    var order: Order?
    
    func getOrderDetails(request: OrdersModel.GetOrderDetails, onComplete: @escaping onComplete<OrdersModel.GetOrderDetailsResponse>){
        API.shared.startAPI(endPoint: .getOrderDetails, req: request, onComplete: onComplete)
    }
    
    func cancelOrder(request: OrdersModel.CancelOrder, onComplete: @escaping onComplete<OrdersModel.GetOrderDetailsResponse>){
        API.shared.startAPI(endPoint: .cancelOrder, req: request, onComplete: onComplete)
    }
    
    func returnProduct(request: OrdersModel.ReturnProduct, onComplete: @escaping onComplete<OrdersModel.GetOrderDetailsResponse>){
        API.shared.startAPI(endPoint: .ReturnProduct, req: request, onComplete: onComplete)
    }
    
    func refundTabbyPayment(request: TabbyRefundPayment.Request ,paymentId: String, onComplete: @escaping onComplete<TabbyRefundPayment.Response>){
        PaymentAPI.shared.startAPITabby(endPoint: "https://api.tabby.ai/api/v1/payments/\(paymentId)/refunds",
                                        req: request,
                                        headers: [.authorization(bearerToken: UserDefaultsManager.config.data?.settings?.tabbySecretKey ?? "")],
                                        onComplete: onComplete)
    }
}

enum TabbyRefundPayment{
    struct Request : Codable {
        let amount: String
        let reason: String
    }
    
    struct Response :Codable {
        let id: String?
        let createdAt, expiresAt: String?
        let amount, currency, welcomeDescription, status: String?
        let isExpired, test: Bool?
    }
}

struct tRequest: Codable {
    
}
