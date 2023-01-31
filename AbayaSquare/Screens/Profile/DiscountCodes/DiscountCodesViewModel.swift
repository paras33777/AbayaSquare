//
//  DiscountCodesViewModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/1/21.
//

import Foundation

class DiscountCodesViewModel {
    
    var coupons: [Offer] = []
    var searchResults: [Offer] = []
    var couponCode: String?
    
    func getDiscountCodes(onComplete: @escaping onComplete<DiscountCodesModel.Response>){
        API.shared.startAPI(endPoint: .getCouponsList, req: DiscountCodesModel.Request(), onComplete: onComplete)
    }
}

enum DiscountCodesModel {
    struct Request: Codable {
    }
    
    struct Response: GenericResponse {
        var status: Bool?
        var responseMessage: String?
        var errors: [ResponseError]?
        let appContents: [Offer]?
    }
}
