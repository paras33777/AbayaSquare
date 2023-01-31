//
//  HomeModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/31/21.
//

import Foundation

enum HomeModel {
    struct Request: Codable {
        let page: Int?
    }
    
    struct Response: GenericResponse {
        var status: Bool?
        var responseMessage: String?
        var errors: [ResponseError]?
        var products: [Product]?
        let resultCount: Int?
        var hasMorePage: Bool?
    }
}

class Product:Codable {
    var id: Int
    let name: String?
    let nameEn: String?
    let nameAr: String?
    let discountRatio: Double?
    let details: String?
    let mainImage: String?
    let sliderImageUrl: String?
    let featureImageUrl: String?
    var inFavorite: Bool?
    var cod:Int?
    let hasDiscount: Bool?
    let isFeature: Int?
    let salePrice, price: Double?
    let annotation: String?
    let annotationAr: String?
    let annotationEn: String?
    let designer: Designer?
    let sizes: [Size]?
    let offer: Offer?
    let category: Category?
    let relatedProducts: [Product]?
    let images: [String]?
    let imageUrl: String?
    let clickable : Int?
}

struct Offer: Codable, Hashable {
    let id: Int
    let startDate, expireDate: String?
    let countOfUse: Int?
    let discountRatio: Double?
    let code: String?
    let flag : Int?
    let show : Int?
    let designer: Designer?
    
    static func == (lhs: Offer, rhs: Offer) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Designer: Codable {
    var id: Int
    var imageUrl, imageThumbnailUrl: String?
    var name: String?
    var returnPolicy: String?
    
    init(id: Int,name: String) {
        self.id = id
        self.name = name
    }
}

struct Size: Codable,Hashable {
    var sizeId: Int?
    var id: Int?
    var productSizeId: Int?
    var size: String?
    var name: String?
    var isSelected: Bool? = false
    var productsCount: Int?
    var qty: Int?
    
    static func == (lhs: Size, rhs: Size) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(id: Int,name:String) {
        self.id = id
        self.name = name
    }
}
