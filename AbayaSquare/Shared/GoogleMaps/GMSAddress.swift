//
//  GMSAddress.swift
//  HomeFoodCheif
//
//  Created by Mohamed Zakout on 13/12/2020.
//

import Alamofire

class GMSAddress {
    static let shared = GMSAddress()
    
    var response: GMSResponse?
    
    func getAddress(latitude: Double, longitude: Double, onComplete: @escaping (_ response: GMSResponse?) -> Void) {
        let lang = L102Language.isRTL ? "ar" : "en"
        let google_map_key = "AIzaSyDD7WH1Qz2mvUUDuDvSSY6uUxQdOV2J3do"
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=\(google_map_key)&language=\(lang)"
        
        AF.cancelAllRequests()
        AF.request(url).validate().responseData { [weak self] response in
            guard let self = self else { return }
            switch response.result {
                case .success(let response) : self.response = GMSResponse.decode(response)
                case .failure(let error)    : print(error.localizedDescription)
            }
            onComplete(self.response)
        }
    }
}
