//
//  DesignerDetailsRouter.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import Foundation
import UIKit

protocol DesignerDetailsDataPass {
    var dataSource: DesignerDetailsDataSource? {get set}
}

class DesignerDetailsRouter:DesignerDetailsDataPass{
    
    weak var viewController: DesignerDetailsVC?
    var dataSource: DesignerDetailsDataSource?
    
    func goToSort(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "SortVC") as! SortVC
        viewController?.presentBottomSheet(vc)
    }
    
    func goToFilter(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel.designerId = dataSource?.designerId
        vc.viewModel.categoryId = dataSource?.categoryId
        vc.delegate = viewController
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
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
