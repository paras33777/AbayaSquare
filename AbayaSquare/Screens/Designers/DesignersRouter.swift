//
//  DesignersRouter.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import Foundation

protocol DesignersDataPass {
    var dataSource: DesignersDataSource? {get set}
}

class DesignersRouter: DesignersDataPass {
    
    weak var viewController: DesignersVC?
    var dataSource: DesignersDataSource?
    
    func goToDesignerDetails(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "DesignerDetailsVC") as! DesignerDetailsVC
        vc.viewModel.designer = dataSource?.designer
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToProductDetails(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel.productId = dataSource?.productId ?? 0
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToSearch(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        vc.hidesBottomBarWhenPushed = true
        vc.type = .SearchDesigners
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToCategories(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesVC
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToDesignerDetailsWithProducts(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "DesignerDetailsVC") as! DesignerDetailsVC
        vc.viewModel.products = dataSource?.sliderProducts ?? []
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
