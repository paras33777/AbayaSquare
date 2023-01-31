//
//  .swift
//  AbayaSquare
//
//  Created by Pratibha on 29/08/22.
//

import Foundation

struct DiscountModelClass:Codable {
    var coupon: Coupons?

}
struct Coupons: Codable {
    var id : Int?
    var store_id : String?
    var start_date : String?
    var expire_date : String?
    var count_of_use : Int?
    var count_of_use_per_customer : String?
    var discount_ratio : Int?
    var code : String?
    var is_active : Int?
    var created_at : String?
    var updated_at : String?
    var deleted_at : String?
    var flag : Int?
    var show : Int?
    var limit : Int?
    var used_count : Int?

}

typealias discountModelClass = DiscountModelClass
