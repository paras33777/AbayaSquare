
import Foundation
import GoogleMaps
import Tabby
class Configuration {
    static var isConfigSuccess = false
    
    class func configure(){
        API.shared.startAPI(endPoint: .getConfig, req: ConfigModel.Request()) { (result: Response<ConfigModel.Response>) in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    class func onSuccess(_ response: ConfigModel.Response) {
        UserDefaultsManager.config = response
        GMSServices.provideAPIKey("AIzaSyDD7WH1Qz2mvUUDuDvSSY6uUxQdOV2J3do")
        TabbySDK.shared.setup(withApiKey: UserDefaultsManager.config.data?.settings?.tabbyPublicKey ?? "")
        isConfigSuccess = true
        NotificationCenter.default.post(name: .ConfigDidSuccess, object: nil)
        
    }
    
    class func onFailure(_ error: Error) {
        MainHelper.shared.showErrorMessage(error)
    }
}

enum ConfigModel {
    struct Request: Codable {
        
    }
    
    struct Response: GenericResponse {
        var status: Bool?
        var responseMessage: String?
        var errors: [ResponseError]?
        var data: Settings?
    }
}

struct Settings: Codable {
    let settings: Config?
    let countriesPhoneList: [String]?
    let splashImages: [String]?
    let sizesImage: String?
}

struct Config: Codable {
    let name, email, mobile, address: String?
    let currencyAr, currencyEn, tax, deliveryPrice: String?
    let whatsapp: String?
    let ios, android: String?
    let facebook: String?
    let mapGeolocationKey, pusherSecret, pusherAppID, pusherAuthKey: String?
    let firebaseKey, deleteUserNotificationPeriod, deleteGlobalNotificationPeriod, aboutUsAr: String?
    let aboutUsEn, termsAndConditionsAr, termsAndConditionsEn, privacyAndPolicyAr: String?
    let privacyAndPolicyEn, projectNameAr, projectNameEn: String?
    let twitter, snapchat, instagram: String?
    let internalShippingCost, externalShippingCost: String?
    let pointsToCashOneSar,splashPromotionTextAr,referralRegisterPoints: String?
    let tabbyPublicKey, tabbySecretKey: String?
    let randomFrom, randomTo: String?
}
