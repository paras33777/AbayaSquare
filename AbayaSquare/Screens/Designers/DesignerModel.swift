//
//  DesignerModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/1/21.
//

import Foundation

enum DesignerModel {
    struct Request: Codable {
        let page: Int?
    }
    
    struct Response: GenericResponse {
        var status: Bool?
        var responseMessage: String?
        var hasMorePage: Bool?
        var errors: [ResponseError]?
        let designers: [Designer]?
        var products: [Product]?
        var sliders: [DesignerSlider]?
    }
}

struct DesignerSlider : Codable {
    let clickable : Int?
    let createdAt : String?
    let id : Int?
    let image : String?
    let imageUrl : String?
    let products : [Product]?
    let updatedAt : String?
}
