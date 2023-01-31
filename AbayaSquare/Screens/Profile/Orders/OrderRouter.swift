//
//  OrderRouter.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/25/21.
//

import Foundation

protocol OrderDataPass {
    var dataSource: OrderDataSource? {get set}
}

class OrderRouter: OrderDataPass{
    weak var viewController: OrdersVC?
    var dataSource: OrderDataSource?
    
    func goToOrderDetails(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsVC") as! OrderDetailsVC
        vc.viewModel.orderId = dataSource?.orderId
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
