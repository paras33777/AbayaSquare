//
//  DeviceKeyModel.swift
//  VegetablesApp
//
//  Created by Ayman  on 1/10/21.
//

import Foundation

struct DeviceKeyModel {
    struct Request: Codable {
        var token = AppDelegate.deviceKey
    }
    
    struct Response: GenericResponse {
        var status: Bool?
        var responseMessage: String?
        var errors: [ResponseError]?
    }
}
