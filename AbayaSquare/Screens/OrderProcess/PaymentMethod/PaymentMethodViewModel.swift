//
//  PaymentMethodViewModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/6/21.
//

import Foundation

protocol PaymentMethodDataSource {
    var paymentTransactionUrl: String? {get set}
    var isPaymentCash: Int? {get set}
    var errorMsg: String? {get set}
}

class PaymentMethodViewModel: PaymentMethodDataSource {
    
    static var shared = PaymentMethodViewModel()
     
    let email = User.currentUser?.email ?? ""
    let mobile = User.currentUser?.mobile.emptyIfNull.suffix(9) ?? ""
    let name = User.currentUser?.name ?? ""
    var isPaymentCash: Int?
    var payments: [PaymentType] = []
    var request =  AddOrderModel.Request()
    var selectedPaymentType: PaymentType?
    var total: Double = 0.0
    var paymentTransactionUrl: String?
    var errorMsg: String?
    var tabbyPaymentType: TabbyPaymentType = .Installments
    var isCashEnabled = 0
    var selectedAddress: Address?
    var tabbyPaymentResponse: TabbyCheckoutResponse?
    var addOrderResponse = AddOrderModel.Response()
    
    func getPaymentMethods(onComplete: @escaping onComplete<PaymentMethodModel.Response>){
        API.shared.startAPI(endPoint: .getPaymentMethods, req: PaymentMethodModel.Request(), onComplete: onComplete)
    }
    
    func addOrder(onComplete: @escaping onComplete<AddOrderModel.Response>){
        API.shared.startAPI(endPoint: .addOrder, req: request, onComplete: onComplete)
    }
    
    func checkoutOrder(request: TabbyCheckoutRequestModel,onComplete: @escaping onComplete<TabbyCheckoutResponse>){
        PaymentAPI.shared.startAPITabby(endPoint: "https://api.tabby.ai/api/v2/checkout",
                                        req: request,
                                        headers: [.authorization(bearerToken: UserDefaultsManager.config.data?.settings?.tabbyPublicKey ?? "")],
                                        onComplete: onComplete)
    }
    
    func updateUserData(onComplete: @escaping onComplete<AuthModel.Response>){
        API.shared.startAPI(endPoint: .getUserData, req: WalletModel.Request(), onComplete: onComplete)
    }
    
    func captureTabbyPayment(request:CaptureTabbyPaymentRequest,paymentId: String, onComplete: @escaping onComplete<CaptureTabbyPaymentResponse>){
        PaymentAPI.shared.startAPITabby(endPoint: "https://api.tabby.ai/api/v1/payments/\(paymentId)/captures",
                                        req: request,
                                        headers: [.authorization(bearerToken: UserDefaultsManager.config.data?.settings?.tabbySecretKey ?? "")],
                                        onComplete: onComplete)
    }
    
    func confirmPayment(request: ConfirmPaymentRequest,onComplete: @escaping onComplete<AddOrderModel.Response>){
        API.shared.startAPI(endPoint: .confirmPayment, req: request, onComplete: onComplete)
    }
    
    //MARK: - AFTER TAMARA API

    
    func afterTamaraAPI(request: AfterTamaraRequest,onComplete: @escaping onComplete<TamaraModel.Response>){
        API.shared.startAPI(endPoint: .afterTamara, req: request, onComplete: onComplete)
    //    API.shared.startAPI(endPoint: .afterTamara, req: request, onComplete: onComplete)
    }
    
}


struct ConfirmPaymentRequest: Codable {
    let orderId: Int?
    let paymentId: String?
    let paymentTypeId: Int?
    let applePayRefernce: String?
}

struct AfterTamaraRequest: Codable {
    let order_id: String?
    let tamaraOrderId: String?
}

struct CaptureTabbyPaymentRequest: Codable {
    let id, amount, taxAmount, shippingAmount: String?
    let discountAmount, createdAt: String?
//    let items: [JSONAny]?
}

struct CaptureTabbyPaymentResponse: Codable {
    
}
