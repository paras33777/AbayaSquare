//
//  FilterRouter.swift
//  AbayaSquare
//
//  Created by Ayman  on 7/1/21.
//

import Foundation

protocol FilterDataPass {
    var dataSource: FilterDataSource? {get set}
}

class FilterRouter: FilterDataPass {
    var dataSource: FilterDataSource?
    
    weak var viewController: FilterVC?
    
    func goToFilterResults(){
        let vc = viewController?.storyboard?.instantiateViewController(identifier: "DesignerDetailsVC") as! DesignerDetailsVC
        vc.viewModel.filterResponse = dataSource?.filterResponse
        vc.viewModel.filterPaggingRequest = dataSource?.homeFiltetRequest ?? FilterModel.FiltetProductsRequest()
        vc.viewModel.isFormFilterHome = 1
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }    
}
