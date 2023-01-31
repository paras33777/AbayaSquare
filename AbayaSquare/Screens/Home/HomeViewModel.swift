//
//  HomeViewModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/31/21.
//

import Foundation

protocol HomeDataSource {
    var offerProducts: [Product]? {get set}
//    var allProducts: [Product] {get set}
    var productId: Int {get set}
}
class HomeViewModel: HomeDataSource {
    
    var offerProducts: [Product]?
    var productId = 0
    var allProducts: [Product] = []
    var mostSellingProducts: [Product] = []
    var offers: [OfferHomeSlider] = []

    func getHome(request: HomeModel.Request,onComplete: @escaping onComplete<HomeModel.Response>){
        API.shared.startAPI(endPoint: .getHome, req: request, onComplete: onComplete)
    }
    
    func getMostSelling(onComplete: @escaping onComplete<HomeModel.Response>){
        API.shared.startAPI(endPoint: .getMostSelling, req: HomeModel.Request(page: nil), onComplete: onComplete)
    }
    
    func getOffers(onComplete: @escaping onComplete<OffersModel.Response>){
        API.shared.startAPI(endPoint: .getOffers, req: HomeModel.Request(page: nil), onComplete: onComplete)
    }
    
    func addToFav(request: AddToFavorite.Request, onComplete: @escaping onComplete<AddToFavorite.Response>){
        API.shared.startAPI(endPoint: .addRemoveFavorite, req: request, onComplete: onComplete)
    }
}
