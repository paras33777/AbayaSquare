//
//  PaymentMethodRouter.swift
//  AbayaSquare
//
//  Created by Ayman  on 7/5/21.
//

import Foundation

protocol PaymentMethodDataPass {
    var dataSource: PaymentMethodDataSource? {get set}
}

class PaymentMethodRouter: PaymentMethodDataPass {
    
    weak var viewController: PaymentMethodVC?
    var dataSource: PaymentMethodDataSource?
    
    
    func goToPaymentWebView(){
        let vc = viewController?.storyboard?.instantiateViewController(identifier: "PaymentWebViewVC") as! PaymentWebViewVC
        vc.transaction = dataSource?.paymentTransactionUrl
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToSuccess(){
        let vc = viewController?.storyboard?.instantiateViewController(identifier: "SuccessVC") as! SuccessVC
        viewController?.navigationController?.pushViewController(vc, animated: true)
        CoreDataManager.emptyBasket()
        CoreDataManager.deleteAllCoupons()
        vc.isPaymentCash = dataSource?.isPaymentCash ?? 0
        NotificationCenter.default.post(name: .UserDidAddProduct, object: nil)
    }
    
    func goToFalilure(){
        let vc = viewController?.storyboard?.instantiateViewController(identifier: "SuccessVC") as! SuccessVC
        vc.errorMsg = dataSource?.errorMsg ?? ""
        vc.vcCase = .Failure
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
