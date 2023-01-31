//
//  HomeRouter.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/26/21.
//

import Foundation

protocol HomeDataPass {
    var dataSource: HomeDataSource? {get set}
}

class HomeRouter:HomeDataPass {
    
    weak var viewController: HomeVC?
    var dataSource: HomeDataSource?
    
    func goToProductDetails(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel.productId = dataSource?.productId ?? 0
        viewController?.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func goToSearch(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        vc.hidesBottomBarWhenPushed = true
        vc.type = .SearchProducts
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToCategories(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesVC
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToFilter(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        vc.hidesBottomBarWhenPushed = true
        vc.vcCase = .HomeFilter
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToDesignerDetails(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "DesignerDetailsVC") as! DesignerDetailsVC
        vc.viewModel.products = dataSource?.offerProducts ?? []
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
