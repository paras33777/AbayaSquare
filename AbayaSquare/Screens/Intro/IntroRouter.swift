//
//  IntroRouter.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/27/21.
//

import Foundation
import UIKit

class IntroRouter {
    
    weak var viewController: IntroVC?
    
    func goToHome(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "Root") as! AppTabBar
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true, completion: nil)
    }
    
    func goToLogin(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "authNav") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        let loginVC =  vc.viewControllers[0] as! LoginVC
        loginVC.isFromIntro = 1
        viewController?.present(vc, animated: true, completion: nil)
    }
}
