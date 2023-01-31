//
//  FavouriteRouter.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import Foundation

protocol FavoriteDataPass {
    var dataSource: FavoriteDataSource? {get set}
}

class FavouriteRouter: FavoriteDataPass{
    
    weak var viewController: FavouriteVC?
    var dataSource: FavoriteDataSource?
    
    func goToProductDetails(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel.productId = dataSource?.productId ?? 0
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToCategories(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesVC
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
