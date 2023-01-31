//
//  OffersModel.swift
//  AbayaSquare
//
//  Created by Afnan MacBook Pro on 08/05/2022.
//

import Foundation

enum OffersModel {
    
    struct Request: Codable {
        let page: Int?
    }
    
    struct Response: GenericResponse {
        var errors: [ResponseError]?
        var offers : [OfferHomeSlider]?
        var responseMessage : String?
        var status : Bool?
        var resultCount: Int?
        var hasMorePage: Bool?
    }
}
struct OfferHomeSlider : Codable {

    let clickable : Int?
    let createdAt : String?
    let id : Int?
    let image : String?
    let imageUrl : String?
    let products : [Product]?
    let updatedAt : String?
    
}
