
import Alamofire

var BASE_URL = "https://abayasquare.com/api/v1/"
//var BASE_URL = "https://abaya.smart.sa/abaya/api/v1/"

let currency = "SAR"
let countryCode = "SA"
let MERCHANT_USER = "eng.alshammariak@gmail.com"
let MERCHANT_PASS = "Abayasq199$"
let HOST = "https://api.tamara.co"

let MERCHANT_TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhY2NvdW50SWQiOiI2Yjg5ZWQ0Ny1kYzEwLTQ1NzItOTFjZi02NGJjMTRjMzIxZTAiLCJ0eXBlIjoibWVyY2hhbnQiLCJzYWx0IjoiZGY4MjZmZWE5ZTZmOTg4NzBiODBmOGMyNzE3MzgxYjkiLCJpYXQiOjE2NjA2NTgyMjYsImlzcyI6IlRhbWFyYSBQUCJ9.qf0Vo4kcuQRxpevRmyubpZu-f7OM5mk4dKl80g-xyR8qPsll5Mao-MwOT16Kfw20aI2q-Jl_WVeQs_Nn2vROs5zh97QfYR7ip2i6kFGF3NSCQKmsHQKpZ7Ih8RWxnKRnAihyVmcKx-ZsAa8HPHB-6t92IU8LOS2cYG8kVfiP5K10MgYCj2M8EZKHrSvWsASeyx8QyH2Uc7Dp24DSg3u2oxNkCqo_vyLZP4IAh0CVVM8-OHk18OBsMPrXQ8AOga2o1tWnPCzQVYxZ3HtFzY3ifum8bQVls4flIkL1e1tTKFstnlf-ea0r8VVAr5vQf1rRA454r2jguNh4zTu6Fi85ew"


//let MERCHANT_TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhY2NvdW50SWQiOiI5YmZlNzg5Ny1hNTFkLTRhMDktYTM5Zi01ZTBmM2M4M2Y5ZDMiLCJ0eXBlIjoibWVyY2hhbnQiLCJzYWx0IjoiZTQ4NjIzNGYyMjA0YmUwOGYyMDJmNDhhNDg5ZmViZmEiLCJpYXQiOjE2NjA0ODM5MjQsImlzcyI6IlRhbWFyYSJ9.f6LZca2btJWBN-N9sGQ7GdVwsLPevmkrJur4GdCqwZsRrgvEul1oveFMbS7lTDd0lcTJ54RNvZ4T1QnP45gm89x0-FyB4ltHk3zj3K4Q1iIM3Bcx5Q7AWt-f450t7cxOneo9ij2TYL6Iu7LpnOWUWbhA2hUAiu582TGaTgnMwFhds_ykiPOnLh2ty1Ri4_dND0oQcbV_sxnaKZvXXiZh2_yBVb7ECyUTKxvDZ1XlWLh9ITKS7CVViY87YfjxY28xt_tDQQAlQFH76A2lQNXLvIMUbIOdjCJWPz53nK8ie17IEDIphcxSY0bLDBrNk3PfPh592038coCEI1kS1yrNBA"

//let currency = "SAR"
//let countryCode = "SA"
//let MERCHANT_USER = "ios-sdk@tamara.co"
//let MERCHANT_PASS = "9x!077G@Thzw"
//let HOST = "https://api-sandbox.tamara.co"
//
//let MERCHANT_TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhY2NvdW50SWQiOiIxMWFjZmM5Zi00YjgxLTRlNDQtYmEyMy04MmFkNGVkZGNlZGYiLCJ0eXBlIjoibWVyY2hhbnQiLCJzYWx0IjoiYTVlZmEwYWU2NmI4OGQyOWZjNWY2OGI1ZjRjZTFhN2IiLCJpYXQiOjE2MDM2ODQxMTYsImlzcyI6IlRhbWFyYSJ9.Wtv2f1Q49Fet1x4Ua-0ld2-p6BwEVRAhfpXRGuMXH-PeeB89IjnKGvoWW4lp0woUQ5MjCOQzuH9mec6cx15-ZxqWd4ZkAf1LZUEZZWcFBvpgjaACQQbYu0AcKfmO7B-JCexfoT5jVjz118b0T4o1zOnOyAfTITJKcjoYL4JRa0T2ktHoMNqjQ1S0zl0iFLgQU0phaX6o-3xrqF7WSOA1hMQme0ory4Al5YnE9IzTT-DdRe8u2dq7nNsowzODe_i6TWhBJWEvAv1ujUvt3DLkL4RzqKHqML4wUy1TPu_LmPLOwhwaiAxNNl72APZXtMBSgR74-xEPOujSwxSWI6UdVw"
enum EndPoints: String {
    
    //MARK: - GetData:
    case getCategories                  = "categories-list"
    case getappContent                  = "app-content"
    case getConfig                      = "app-settings"
    case getCouponsList                 = "coupons-list"
    case getDesignersList               = "designers-list"
    case getHome                        = "home-products"
    case getMostSelling                 = "most-selling"
    case getOffers                      = "offers"
    case getFavorite                    = "customer/product/favorite-list"
    case filterProducts                 = "filter-products"
    case getProductDetails              = "get-product-details"
    case getTrendingSearch              = "trending-search"
    case getTrendingDesignerSearch      = "trending-designer-search"
    case getPaymentMethods              = "payment-types"
    case getNotifications               = "customer/get-customer-notification"
    case getFilterContent               = "filter-settings"
    case updateProductPrices            = "update-products-prices"
    case getUserData                    = "customer/my-data"
    case getCities                      = "cities-list"
    case clearNotifications             = "customer/clear-notifications"
    case deleteNotification             = "customer/delete-notification"
    
    //MARK: - PostData:
    case contactUs                      = "contact-us"
    case checkCoupon                    = "check-coupon"
    case convertPoints                  = "customer/convert-points-to-cash"
    case cancelOrder                    = "customer/order/cancel-order"
    case ReturnProduct                  = "customer/order/return-product"
    case checkPromo                     = "check-promo"
    
    //MARK: - Customer Authantication:
    case register                       = "customer/auth/login-register"
    case activateMobile                 = "customer/auth/verify-login-code"
    case updateProfile                  = "customer/update-profile"
    case updateDvieceKey                = "update-fcm-token"
    case resendCode                     = "customer/auth/resend-verify-code"
    case logoutUser                     = "customer/auth/logout"
    case deleteAccount                  = "customer/delete-user"
    
    //MARK: - Customer Address:
    case addAddres                      = "customer/address/add"
    case deleteAddress                  = "customer/address/delete"
    
    //MARK: - CustomerOrder:
    case addOrder                       = "customer/order/place-new"
    case confirmPayment                 = "customer/order/confirm-payment"
    case getOrders                      = "customer/order/list"
    case getOrderDetails                = "customer/order/get-order-details"
    case addRemoveFavorite              = "customer/product/add-remove-product-wishlist"
    
    //MARK: - AFTER TAMARA
    
    case afterTamara                    = "customer/order/update-tamara"
    
    
    //MARK: - Tabby Requests:
    case tabbyPayment = "https://api.tabby.ai/api/v1/payments"
    
    var method: HTTPMethod {
        switch self {
        case .getappContent,
             .getConfig,
             .getCouponsList,
             .getDesignersList,
             .getHome,
             .getOrders,
             .getFilterContent,
             .getOrderDetails,
             .getCities,
             .clearNotifications,
             .getPaymentMethods,
             .getTrendingSearch,
             .getProductDetails,
             .updateProductPrices,
             .filterProducts,
             .getUserData,
             .getFavorite,
             .getTrendingDesignerSearch,
             .logoutUser,
             .getNotifications,
             .getCategories,
             .getMostSelling,
             .getOffers: return .get
            
        case .register,
             .activateMobile,
             .updateProfile,
             .updateDvieceKey,
             .resendCode,
             .addAddres,
             .deleteAddress,
             .checkPromo,
             .addOrder,
             .addRemoveFavorite,
             .deleteNotification,
             .ReturnProduct,
             .checkCoupon,
             .cancelOrder,
             .convertPoints,
             .confirmPayment,
             .tabbyPayment,
             .afterTamara,
             .contactUs: return .post
            
        case .deleteAccount : return .post
        
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .addOrder: return JSONEncoding.default
        default: return URLEncoding.default
        }
    }
}

func printResponse(_ data: Data?) {
    guard let data = data else { return }
    let string = "\(String(data: data, encoding: .nonLossyASCII).emptyIfNull)"
    print(string.replacingOccurrences(of: "\\", with: ""))
}

func printObject<T: Codable>(_ t: T) {
    for value in t.toDic() {
        print("\(value.key): \(value.value)\n")
    }
}


func generatePhoneNumber(_ country: String = "SA") -> String {
    if (country == "KW") {
        let kwPrefix = ["551", "552"];
        return kwPrefix.randomElement()! + random(digits: 6);
    } else {
        let prefix = ["50", "55"];
        return prefix.randomElement()! + random(digits: 7)
    }
}

func random(digits:Int) -> String {
    var number = String()
    for _ in 1...digits {
       number += "\(Int.random(in: 1...9))"
    }
    return number
}
