//
//  FavouriteViewModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/31/21.
//

import Foundation

protocol FavoriteDataSource {
    var productId: Int {get set}
}

class FavouriteViewModel: FavoriteDataSource{
    
    var productId = 0
    var products: [Product] = []
    
    func getFavourites(request: HomeModel.Request,onComplete: @escaping onComplete<HomeModel.Response>){
        API.shared.startAPI(endPoint: .getFavorite, req: request, onComplete: onComplete)
    }
    
    func addToFav(request: AddToFavorite.Request, onComplete: @escaping onComplete<AddToFavorite.Response>){
        API.shared.startAPI(endPoint: .addRemoveFavorite, req: request, onComplete: onComplete)
    }
}


