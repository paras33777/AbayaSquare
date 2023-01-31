//
//  OrdersViewModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/7/21.
//

import Foundation

protocol OrderDataSource {
    var orderId: Int? {get set}
}

class OrdersViewModel: OrderDataSource {
    
    var orders: [Order] = []
    var orderId: Int?
    
    func getOrders(onComplete: @escaping onComplete<OrdersModel.Response>) {
        API.shared.startAPI(endPoint: .getOrders, req: OrdersModel.Request(), onComplete: onComplete)
    }
}

