
import Foundation
import UIKit

class UserDefaultsManager {
    @UserDefault("config", defaultValue: nil)
    static var config: ConfigModel.Response!
    
    @UserDefault("isFirstLaunch", defaultValue: true)
    static var isFirstLaunch: Bool
    
    @UserDefault("isMobile" , defaultValue: 0)
    static var isMobile: Int
    
    @UserDefault("isPromoCodeApplied", defaultValue: false)
    static var isPromoCodeApplied: Bool
    
    @UserDefault("isDiscountCodeApplied", defaultValue: false)
    static var isDiscountCodeApplied: Bool
    
    @UserDefault("token", defaultValue: "")
    static var token: String?
    
    @UserDefault("promoCode" , defaultValue: nil)
    static var promoCode: PromoSettings!
   
    @UserDefault("coupon" , defaultValue: nil)
    static var coupon: Coupons!
    
    
    @UserDefault("isCashEnabled", defaultValue: 0)
    static var isCashEnabled: Int
    
    @UserDefault("cod", defaultValue: 0)
    static var cod: Int
    
    @UserDefault("flag", defaultValue: 0)
    static var flag: Int
    
    @UserDefault("show", defaultValue: 0)
    static var show: Int
   
    @UserDefault("discount_ratio", defaultValue: 0.0)
    static var discount_ratio: Double
    
  
    
}


@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String
    let defaultValue: T
    
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    
    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                return defaultValue
            }
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
