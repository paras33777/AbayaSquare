//
//  CartRouter.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/26/21.
//

import Foundation
import UIKit

protocol CartDataPass {
    var dataSource: CartDataSource? {get set}
}

class CartRouter: CartDataPass {
    
    weak var viewController: CartVC?
    var nav: UINavigationController?
    var dataSource: CartDataSource?
    
    func goToAddAddress(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "AddAddressVC") as! AddAddressVC
        vc.delegate = viewController
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToDisountCodes(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "DiscountCodesVC") as! DiscountCodesVC
        vc.hidesBottomBarWhenPushed = true
        vc.delegate = viewController
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToSelectAddress(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "SelectAddressVC") as! SelectAddressVC
        vc.nav = nav
        vc.delegate = viewController
        viewController?.presentBottomSheet(vc)
    }
    
    func goToPaymentMethods(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "PaymentMethodVC") as! PaymentMethodVC
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel.request = dataSource?.request ?? AddOrderModel.Request()
        vc.viewModel.total = dataSource?.total ?? 0
        vc.viewModel.isCashEnabled = dataSource?.isCashEnabled ?? 0
        vc.viewModel.selectedAddress = dataSource?.selectedAddress
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToNotifications(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToLogin(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToCategories(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesVC
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToProductDetails(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel.productId = dataSource?.productId ?? 0
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
