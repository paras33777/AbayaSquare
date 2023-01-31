//
//  DesignerDetailsViewModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/1/21.
//

import Foundation

protocol DesignerDetailsDataSource {
    var productId: Int {get set}
    var designerId: Int? {get set}
    var categoryId: Int? {get set}
}

class DesignerDetailsViewModel: DesignerDetailsDataSource {
    
    
    var filterPaggingRequest = FilterModel.FiltetProductsRequest()
    var filterResponse: HomeModel.Response?
    var isFormFilterHome = 0
    var isFromFilter = 0
    var isFilterActive = 0
    var page: Int = 1
    var isPageRefreshing:Bool = false
    var designers: [Designer] = []
    var designer: Designer?
    var products: [Product] = []
    var filtedProducts: [Product] = []
    var product: Product?
    var designerId: Int?
    var categoryId: Int?
    var category: Category?
    var categories: [Category] = []
    var productId = 0
    
    func getDesignerProducts(request: FilterModel.FiltetProductsRequest,onComplete: @escaping onComplete<HomeModel.Response>){
        API.shared.startAPI(endPoint: .filterProducts, req: request, onComplete: onComplete)
    }
    
    func filterProducts(request:FilterModel.FiltetProductsRequest, onComplete: @escaping onComplete<HomeModel.Response>){
        API.shared.startAPI(endPoint: .filterProducts, req: request, onComplete: onComplete)
    }

    func addToFav(request: AddToFavorite.Request, onComplete: @escaping onComplete<AddToFavorite.Response>){
        API.shared.startAPI(endPoint: .addRemoveFavorite, req: request, onComplete: onComplete)
    }
    
    func getCategories(onComplete: @escaping onComplete<CategoryModel.Response>){
        API.shared.startAPI(endPoint: .getCategories, req: CategoryModel.Request(), onComplete: onComplete)
    }
    
    func getDesigners(request: DesignerModel.Request,onComplete: @escaping onComplete<DesignerModel.Response>){
        API.shared.startAPI(endPoint: .getDesignersList, req: request, onComplete: onComplete)
    }
}
