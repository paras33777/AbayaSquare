//
//  AboutModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/1/21.
//

import Foundation

enum AboutModel {
    struct Request: Codable {
    }
    
    struct Response: GenericResponse {
        var status: Bool?
        var responseMessage: String?
        var errors: [ResponseError]?
        let appContents: AboutResponse?
    }
}

struct AboutResponse: Codable {
    let aboutUs: String?
    let privacyAndPolicy: String?
    let termsAndConditions: String?
}
