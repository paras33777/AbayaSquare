//
//  ProductDetailsViewModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/1/21.
//

import Foundation

protocol ProductDetailsDataSource {
    var images: [String] {get set}
    var productId: Int {get set}
    var designer: Designer? {get set}
}

class ProductDetailsViewModel: ProductDetailsDataSource {
    var productId = 0
    var images: [String] = []
    var sizes: [Size] = []
    var relatedProducts: [Product] = []
    var selectedSize: Size?
    var product: Product?
    var designer: Designer?
    let tabbyEnUrl = "https://checkout.tabby.ai/promos/product-page/installments/en/"
    let tabbyArUrl = "https://checkout.tabby.ai/promos/product-page/installments/ar/"
    
    func addToFav(request: AddToFavorite.Request, onComplete: @escaping onComplete<AddToFavorite.Response>){
        API.shared.startAPI(endPoint: .addRemoveFavorite, req: request, onComplete: onComplete)
    }
    
    func getProductDetails(request: ProductDetailsModel.Request, onComplete: @escaping onComplete<ProductDetailsModel.Response>){
        API.shared.startAPI(endPoint: .getProductDetails, req: request, onComplete: onComplete)
    }
}

enum ProductDetailsModel {
    struct Request: Codable {
        let productId: Int?
       
    }
    
    struct Response: GenericResponse {
        var status: Bool?
        var responseMessage: String?
        var errors: [ResponseError]?
        let product: Product? 
    }
}

enum AddToFavorite {
    struct Request: Codable {
        let productId: Int?
    }
    
    struct Response: GenericResponse {
        var status: Bool?
        var responseMessage: String?
        var errors: [ResponseError]?
    }
}
