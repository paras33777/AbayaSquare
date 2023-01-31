//
//  CartViewModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/5/21.
//

import Foundation

protocol CartDataSource {
    var request: AddOrderModel.Request {get set}
    var productId: Int? {get set}
    var total: Double? {get set}
    var isCashEnabled: Int { get set }
    var selectedAddress: Address? {get set}
}

class CartViewModel: CartDataSource {
    
    var request = AddOrderModel.Request()
    var selectedAddress: Address?
    var total: Double?
    var productId: Int?
    var discount: PromoSettings?
    var coupon: Coupons?

    var isCashEnabled = 0
    var deliveryCost: Double = 0
    
    func addToFav(request: AddToFavorite.Request, onComplete: @escaping onComplete<AddToFavorite.Response>){
        API.shared.startAPI(endPoint: .addRemoveFavorite, req: request, onComplete: onComplete)
    }
    
    func updateProductPrices(request: UpdateProductPrices, onComplete: @escaping onComplete<HomeModel.Response>){
        API.shared.startAPI(endPoint: .updateProductPrices, req: request, onComplete: onComplete)
    }
    
    func checkPromoCode(request: PromoCodeModel.Request, onComplete: @escaping onComplete<PromoCodeModel.Response>){
        API.shared.startAPI(endPoint: .checkPromo, req: request, onComplete: onComplete)
    }
    

    
    func getDeliveryCost(addressType: Int) -> Double {
        let addresses = User.currentUser?.addresses ?? []
        var cost = 0.0
        if !addresses.isEmpty {
            if addressType == 1 {
                cost = Double(UserDefaultsManager.config?.data?.settings?.internalShippingCost ?? "") ?? 0
            } else {
                cost =  Double(UserDefaultsManager.config?.data?.settings?.externalShippingCost ?? "") ?? 0
            }
        }
        return cost
    }
    
    func getVatValue() -> String {
        let vat = UserDefaultsManager.config?.data?.settings?.tax ?? "0"
        return vat
    }
    
    func getVatCost() -> Double {
        let tax = Double(UserDefaultsManager.config?.data?.settings?.tax ?? "0") ?? 0
        let price = CoreDataManager.getProductsTotalPrice()
        var totalPrice = 0.0
        totalPrice = price * (tax / 100)
        
        return totalPrice
    }
    
    func getTotalCost(addressType: Int) -> Double {
        let price = CoreDataManager.getProductsTotalPrice()
        let tax = getVatCost()
        let deliveryPrice = getDeliveryCost(addressType: addressType)
        var totalPrice = 0.0
        totalPrice += price
        totalPrice += tax
        totalPrice += deliveryPrice
        return totalPrice
    }
    
    
    func getDiscountPromoCode() -> Double {
        let price = CoreDataManager.getProductsTotalPrice()
        let discountRatio = discount?.promoDiscountRatio.emptyIfNull.toDouble ?? 0
        let discount = (discountRatio * price) / 100
        return discount
    }

    func getTotalWithPromoCodeDiscount(addressType: Int) -> Double{
        let price = CoreDataManager.getProductsTotalPrice()
        let tax = getVatCost()
        let deliveryPrice = getDeliveryCost(addressType: addressType)
        let discount = getDiscountPromoCode()
        var totalPrice = 0.0
        totalPrice += price
        totalPrice -= discount
        totalPrice += tax
        totalPrice += deliveryPrice
        return totalPrice
    }
    
    func getTotalWithCouponCode(addressType: Int) -> Double{
        let price = CoreDataManager.getProductsTotalPrice()
        let tax = getVatCost()
        let deliveryPrice = getDeliveryCost(addressType: addressType)
        let discount = getDiscountPromoCode()
        var totalPrice = 0.0
        totalPrice += price
        totalPrice -= discount
        totalPrice += tax
        totalPrice += deliveryPrice
        return totalPrice
    }
    
    func getProductArray() -> [PlaceOrderModel] {
        let products = CoreDataManager.getProdcuts()
        var orders: [PlaceOrderModel] = []
        products.forEach { prod in
            orders.append(PlaceOrderModel(productId: prod.id,
                                          storeId: prod.designerId
                                          ,couponId: prod.couponId
                                          ,qty: prod.quantity
                                          ,sizeId: prod.sizeId))
            
        }
        return orders
    }
}

struct UpdateProductPrices: Codable {
    let productsList: String?
}

enum PromoCodeModel {
    struct Request: Codable {
        let code: String?
    }
    
    struct Response: GenericResponse {
        var status: Bool?
        var responseMessage: String?
        var errors: [ResponseError]?
        let promoSettings: PromoSettings?
    }
}

struct PromoSettings: Codable {
    let promoCode: String?
    let promoDiscountRatio: String?
    let appCommissionRatio: String?
}



