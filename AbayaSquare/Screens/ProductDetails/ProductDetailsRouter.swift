//
//  ProductDetailsRouter.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/27/21.
//

import Foundation

protocol ProductDetailsDataPass {
    var dataSource: ProductDetailsDataSource? {get set}
}

class ProductDetailsRouter: ProductDetailsDataPass{
    
    weak var viewController: ProductDetailsVC?
    var dataSource: ProductDetailsDataSource?
    
    func goToProductImages(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "PhotosVC") as! PhotosVC
        vc.imagesString = dataSource?.images ?? []
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true, completion: nil)
    }
    
    func goToProductDetails(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
        vc.viewModel.productId = dataSource?.productId ?? 0
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToDiscountCodes(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "DiscountCodesVC") as! DiscountCodesVC
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToCart(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToDesignerDetails(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "DesignerDetailsVC") as! DesignerDetailsVC
        vc.viewModel.designer = dataSource?.designer
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
