//
//  AddAddressViewModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/5/21.
//

import Foundation

class AddAddressViewModel {
    
    var govs: [Gov] = []
    var selectedGov: Gov?
    var cities: [City] = []
    var selectedCity: City? 
    
    func addAddress(request: AddAddressModel.Request,onComplete: @escaping onComplete<AddAddressModel.Response>){
        API.shared.startAPI(endPoint: .addAddres, req: request, onComplete: onComplete)
    }
    
    func getCities(onComplete: @escaping onComplete<CityModel.Response>){
        API.shared.startAPI(endPoint: .getCities, req: CityModel.Request(), onComplete: onComplete)
    }
    
    func deleteAddress(request: AddAddressModel.DeleteAddress,onComplete: @escaping onComplete<AddAddressModel.Response>){
        API.shared.startAPI(endPoint: .deleteAddress, req: request, onComplete: onComplete)
    }
}


enum CityModel {
    struct Request: Codable {
    }
    
    struct Response: GenericResponse {
        var status: Bool?
        var responseMessage: String?
        var errors: [ResponseError]?
        let govs: [Gov]?
    }
}

struct Gov:Codable {
    let id, countryId: Int?
    let name: String?
    let cities: [City]?
}

struct City: Codable {
    let id, govId, cityCode,isCash: Int?
    let name: String?
}

enum AddAddressModel {
    struct Request: Codable {
        var lat: String? = nil
        var lng: String? = nil
        var mobile: String? = nil
        var areaId: Int? = nil
        var cityId: Int? = nil
        var name: String? = nil
        var type: String? = "home"
        var address: String? = nil
        var isInternal: Int? = 0
        
        var isValid: Bool {
            mutating get {
                validate()
                return errorRules.isEmpty
            }
        }
        var errorRules: [ResponseError] = []
        
        mutating private func validate() {
            errorRules.removeAll()
            if name == "" {
                errorRules.append(ResponseError(field: "", error: "Please Enter Name".localized))
            }
            
            if mobile == "" {
                errorRules.append(ResponseError(field: "", error: "Please Enter Mobile Number".localized))
            }
            
            if areaId == nil {
                errorRules.append(ResponseError(field: "", error: "Please Select City".localized))
            }
            
            if cityId == nil {
                errorRules.append(ResponseError(field: "", error: "Please Select Area".localized))
            }
            
            if address == "" {
                errorRules.append(ResponseError(field: "", error: "you must enter the address".localized))
            }
        }
    }
    
    struct DeleteAddress: Codable {
        let addressId: Int?
    }
    
    struct Response: GenericResponse {
        var status: Bool?
        var responseMessage: String?
        var errors: [ResponseError]?
        let customer: User?
    }
}
