//
//  ProfileModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import Foundation
import UIKit

enum ProfileModel {
    case MyOrders
    case Wallet
    case ManageAddress
    case DiscountCodes
    case MyFavourite
    case Notifications
    
    var title: String {
        switch self {
        case .MyOrders          : return "My Orders".localized
        case .Wallet            : return "Wallet".localized
        case .ManageAddress     : return "Manage Address".localized
        case .DiscountCodes     : return "Discount Codes".localized
        case .MyFavourite       : return "My Favourite".localized
        case .Notifications     : return "Notifications".localized
        }
    }
    
    var image: UIImage? {
        switch self {
        case .MyOrders          : return UIImage(named: "ic_my_order")
        case .Wallet            : return UIImage(named: "ic_wallet")
        case .ManageAddress     : return UIImage(named: "ic_address")
        case .DiscountCodes     : return UIImage(named: "ic_discount_codes")
        case .MyFavourite       : return UIImage(named: "ic_my_fav")
        case .Notifications     : return UIImage(named: "ic_notifications")
        }
    }
    
    static var items: [ProfileModel] = []
    
    static func setup(){
        items = [.MyOrders,.Wallet,.ManageAddress,.DiscountCodes,.MyFavourite,.Notifications]
    }
}

enum OtherModel {
    case Language
    case AboutUs
    case PrivacyPolicy
    case TersmAndConditions
    case DeleteAccount
    case Logout
    
    var title: String {
        switch self {
        case .Language              : return "Arabic".localized
        case .AboutUs               : return "About Us".localized
        case .PrivacyPolicy         : return "Privacy Policy".localized
        case .TersmAndConditions    : return "Terms & Conditions".localized
        case .DeleteAccount         : return "Delete Account".localized
        case .Logout                : return "Logout".localized
        }
    }
    
    static var items: [OtherModel] = []
    
    static func setup(){
        items = [.Language,.AboutUs,.PrivacyPolicy,.TersmAndConditions,.DeleteAccount,.Logout]
    }
}


enum OtherModel1 {
    case Language
    case AboutUs
    case PrivacyPolicy
    case TersmAndConditions
    case Logout
    
    var title: String {
        switch self {
        case .Language              : return "Arabic".localized
        case .AboutUs               : return "About Us".localized
        case .PrivacyPolicy         : return "Privacy Policy".localized
        case .TersmAndConditions    : return "Terms & Conditions".localized
        case .Logout                : return "Logout".localized
        }
    }
    
    static var items1: [OtherModel1] = []
    
    static func setup1(){
        items1 = [.Language,.AboutUs,.PrivacyPolicy,.TersmAndConditions,.Logout]
    }
}
enum LogoutModel {
    struct Request: Codable {
    }

    struct Response: GenericResponse {
        var status: Bool?
        var responseMessage: String?
        var errors: [ResponseError]?
    }
}

enum DeleteAccountModel {
    struct Request: Codable {
    }

    struct Response: GenericResponse {
        var status: Bool?
        var responseMessage: String?
        var errors: [ResponseError]?
    }
}
