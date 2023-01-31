//
//  SearchViewModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/1/21.
//

import Foundation

protocol SearchDataSource {
    var designer: Designer? {get set}
    var productId: Int {get set}
}

class SearchViewModel: SearchDataSource {
    var products: [Product] = []
    var designers: [Designer] = []
    var trendingSearch: [TrendingSearch] = []
    
    var designer: Designer?
    var productId = 0
    
    func searchProduct(request: SearchRequest,onComplete: @escaping onComplete<HomeModel.Response>){
        API.shared.startAPI(endPoint: .filterProducts, req: request, onComplete: onComplete)
    }
    
    func searchDesigner(request: SearchRequest,onComplete: @escaping onComplete<DesignerModel.Response>){
        API.shared.startAPI(endPoint: .getDesignersList, req: request, onComplete: onComplete)
    }
    
    func addToFav(request: AddToFavorite.Request, onComplete: @escaping onComplete<AddToFavorite.Response>){
        API.shared.startAPI(endPoint: .addRemoveFavorite, req: request, onComplete: onComplete)
    }
    
    func getTrendingSearch(onComplete: @escaping onComplete<TrendingSearchModel.Response>){
        API.shared.startAPI(endPoint: .getTrendingSearch, req: TrendingSearchModel.Request(), onComplete: onComplete)
    }
    
    func getTrendingDesignerSearch(onComplete: @escaping onComplete<TrendingSearchModel.Response>){
        API.shared.startAPI(endPoint: .getTrendingDesignerSearch, req: TrendingSearchModel.Request(), onComplete: onComplete)
    }
}

enum TrendingSearchModel {
    struct Request: Codable {
    }
    
    struct Response: GenericResponse {
        var status: Bool?
        var responseMessage: String?
        var errors: [ResponseError]?
        let trendingSearch: [TrendingSearch]?
        let trendingDesignersList: [TrendingSearch]?
    }
}

struct TrendingSearch: Codable {
    let id: Int?
    let text: String?
    let resultsCount: Int?
    let createdAt, updatedAt: String?
    let count: Int?
}

struct SearchRequest: Codable {
    let page: Int?
    let name: String?
}
