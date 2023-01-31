//
//  DesignersViewModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/31/21.
//

import Foundation

protocol DesignersDataSource {
    var productId: Int {get set}
    var designer : Designer? {get set}
    var sliderProducts : [Product]? {get set}
}

class DesignersViewModel: DesignersDataSource {
  
    var sliderProducts: [Product]?
    var designers: [Designer] = []
    var products: [Product] = []
    var sliders: [DesignerSlider] = []
    var productId = 0
    var designer : Designer?
    
    func getDesigners(request: DesignerModel.Request,onComplete: @escaping onComplete<DesignerModel.Response>){
        API.shared.startAPI(endPoint: .getDesignersList, req: request, onComplete: onComplete)
    }
}
