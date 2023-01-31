//
//  SearchDesignersRouter.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/26/21.
//

import Foundation

class SearchDesignersRouter {
    
    weak var viewController: SearchVC?
    
    func goToDesignersDetails(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "DesignerDetailsVC") as! DesignerDetailsVC
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
