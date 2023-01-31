//
//  SearchRouter.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/1/21.
//

import Foundation

protocol SearchDataPass {
    var dataSource: SearchDataSource? {get set}
}

class SearchRouter: SearchDataPass{
    
    weak var viewController: SearchVC?
    var dataSource: SearchDataSource?
    
    func goToProductDetails(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel.productId = dataSource?.productId ?? 0
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToDesignerDetails(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "DesignerDetailsVC") as! DesignerDetailsVC
        vc.viewModel.designer = dataSource?.designer
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
