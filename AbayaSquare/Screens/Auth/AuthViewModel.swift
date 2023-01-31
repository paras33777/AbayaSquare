//
//  AuthViewModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/31/21.
//

import Foundation

class AuthViewModel {

    func loginRegiserUser(request: AuthModel.LoginRegister, onComplete: @escaping onComplete<AuthModel.Response>){
        API.shared.startAPI(endPoint: .register, req: request, onComplete: onComplete)
    }
    
    func activateUser(request: AuthModel.Activate, onComplete: @escaping onComplete<AuthModel.Response>) {
        API.shared.startAPI(endPoint: .activateMobile, req: request, onComplete: onComplete)
    }
    
    func resendCode(request: AuthModel.ResendCode, onComplete: @escaping onComplete<ResendResponse>) {
        API.shared.startAPI(endPoint: .resendCode, req: request, onComplete: onComplete)
    }
    
    func updateProfile(request: AuthModel.UpdatePrfile, onComplete: @escaping onComplete<AuthModel.Response>){
        API.shared.startAPIMultiPart(endPoint: .updateProfile, req: request, onComplete: onComplete)
    }
    
    
    
}

struct ResendResponse: GenericResponse {
    var status: Bool?
    var responseMessage: String?
    var errors: [ResponseError]?
}
