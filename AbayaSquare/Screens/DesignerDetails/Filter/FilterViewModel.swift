//
//  FilterViewModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/7/21.
//

import Foundation

protocol FilterDataSource {
    var filterResponse: HomeModel.Response? {get set}
    var homeFiltetRequest: FilterModel.FiltetProductsRequest? {get set}
}

class FilterViewModel: FilterDataSource{
    
    var stings: [String] = ["Category".localized,
                            "Color".localized,
                            "Size".localized,
                            "Price".localized]
    
    var filterResponse: HomeModel.Response?
    var request = FilterModel.FiltetProductsRequest()
    var homeFiltetRequest: FilterModel.FiltetProductsRequest?
    var designerId: Int? 
    var categoryId: Int?
    
    var productCount = 0
    var selectedCategories: [Category] = []
    var selectedSizes: [Size] = []
    var selectedColors: [Color] = []
    
    var categories: [Category] = []
    var searchResults: [Category] = []
    var sizes: [Size] = []
    var colors: [Color] = []
    var maxPrice: Double = 0.0
    var minPrice: Double = 0.0
    
    func getFilterContent(onComplete: @escaping onComplete<FilterModel.Response>){
        API.shared.startAPI(endPoint: .getFilterContent, req: FilterModel.Request(), onComplete: onComplete)
    }
    
    func filterProducts(request:FilterModel.FiltetProductsRequest, onComplete: @escaping onComplete<HomeModel.Response>){
        API.shared.startAPI(endPoint: .filterProducts, req: request, onComplete: onComplete)
    }
}

enum FilterModel {
    struct Request: Codable {
    }
    
    struct Response: GenericResponse {        
        var status: Bool?
        var responseMessage: String?
        var errors: [ResponseError]?
        let categories: [Category]?
        let colors: [Color]?
        let sizes: [Size]?
        let maxPrice: Double?
        let minPrice: Double?
        let productsCount: Int?
    }
    
    struct FiltetProductsRequest: Codable {
        var categoriesList: String? = nil
        var sizesList: String? = nil
        var designerId: Int? = nil
        var colorsList: String? = nil
        var minPrice: Double? = nil
        var maxPrice: Double? = nil
        var categoryId: Int? = nil
        var page: Int? = nil
    }
}

struct Color: Codable,Hashable {
    var id: Int
    var colorHex: String?
    var name: String?
    var isSelected: Bool? = false
    var productsCount: Int?
    
    static func == (lhs: Color, rhs: Color) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
    init(id: Int,name:String,colorHex: String) {
        self.id = id
        self.name = name
        self.colorHex = colorHex
    }
}

