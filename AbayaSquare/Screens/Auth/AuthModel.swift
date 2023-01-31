//
//  AuthModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/31/21.
//

import Foundation

enum AuthModel {
    struct LoginRegister: Codable {
        
        var mobile    : String? = nil
        var email     : String? = nil
        var mobileCode: String? = nil
        var name      : String? = nil
        
        var isValid: Bool {
            mutating get {
                validate()
                return errorRules.isEmpty
            }
        }
        var errorRules: [ResponseError] = []
        mutating private func validate() {
            errorRules.removeAll()
            if mobile == "" {
                errorRules.append(ResponseError(field: "", error: "Please Enter Mobile Number".localized))
            }
            
            if email == "" {
                errorRules.append(ResponseError(field: "", error: "Please Enter Email".localized))
            }
            
        }
        
    }
    
    struct Activate: Codable {
        var mobile: String? = nil
        let code: String
        var email: String? = nil
        
        var isValid: Bool {
            mutating get {
                validate()
                return errorRules.isEmpty
            }
        }
        var errorRules: [ResponseError] = []
        mutating private func validate() {
            errorRules.removeAll()
            if code.isEmpty {
                errorRules.append(ResponseError(field: "", error: "Please Enter Actication code".localized))
            }
        }
    }
    
    struct UpdatePrfile: MutlipartRequest {
        var name: String? = nil
        var mobile: String? = nil
        var email: String? = nil
        var avatar: Data? = nil
        
        var files: [String] = ["avatar"]
    }
    
    struct ResendCode: Codable {
        var mobile: String? = nil
        var email: String? = nil
    }
    
    struct Response: GenericResponse {
        var status: Bool?
        var responseMessage: String?
        var errors: [ResponseError]?
        let customer: User?
    }
}
