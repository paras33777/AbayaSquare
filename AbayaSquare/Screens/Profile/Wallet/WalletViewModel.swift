//
//  WalletViewModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/10/21.
//

import Foundation

class WalletViewModel {
    
    func convertPointsToCash(onComplete: @escaping onComplete<WalletModel.Response>){
        API.shared.startAPI(endPoint: .convertPoints, req: WalletModel.Request(), onComplete: onComplete)
    }
    
    func updateUserData(onComplete: @escaping onComplete<AuthModel.Response>){
        API.shared.startAPI(endPoint: .getUserData, req: WalletModel.Request(), onComplete: onComplete)
    }
}

enum WalletModel {
    struct Request: Codable {
    }
    
    struct Response: GenericResponse {
        var status: Bool?
        var responseMessage: String?
        let customer: User?
        var errors: [ResponseError]?
    }
}
