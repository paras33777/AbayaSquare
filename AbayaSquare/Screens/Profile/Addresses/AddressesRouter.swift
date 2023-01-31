//
//  AddressesRouter.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/25/21.
//

import Foundation

class AddressesRouter {
    
    weak var viewController: AddressesVC?
    
    func goToAddAddress(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "AddAddressVC") as! AddAddressVC
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
 
