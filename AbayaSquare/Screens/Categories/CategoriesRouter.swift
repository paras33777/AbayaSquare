//
//  CategoriesRouter.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/3/21.
//

import Foundation
import UIKit

protocol CategoriesDataPass {
    var dataSource: CategoriesDataSource? {get set}
}

class CategoriesRouter: CategoriesDataPass {
    
    weak var viewController: UIViewController?
    var dataSource: CategoriesDataSource?
    
    func goToCategoriesDetails(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "DesignerDetailsVC") as! DesignerDetailsVC
        vc.viewModel.category = dataSource?.category
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
