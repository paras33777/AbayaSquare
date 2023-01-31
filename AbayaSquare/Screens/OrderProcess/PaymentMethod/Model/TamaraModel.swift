//
//  TamaraModel.swift
//  AbayaSquare
//
//  Created by Shubham on 14/12/22.
//

import Foundation
enum TamaraModel {
    
    struct Request: Codable {
        let order_id: Int?
        let tamaraOrderId: Int?
    }
    struct Response: GenericResponse {
        var status: Bool?
        var responseMessage: String?
        var errors: [ResponseError]?
    }
//    struct Response: GenericResponse {
//        var status: Bool?
//        
//        var responseMessage: String?
//        
//        var errors: [ResponseError]?
//        
//        let order_id: Int?
//        let tamaraOrderId: Int?
//    }
}
