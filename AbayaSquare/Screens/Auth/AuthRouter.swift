//
//  AuthRouter.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/27/21.
//

import Foundation
import UIKit

class AuthRouter {
    
    weak var viewController: UIViewController?
    
    var isFromIntro = 0
    
    func goToPolicy(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
        vc.type = .PrivacyPolicy
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToTerms(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
        vc.type = .TermsAndConditions
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToActivate(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "ActivateVC") as! ActivateVC
        vc.isFormIntro = isFromIntro
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToHome() {
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "Root") as! UITabBarController
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true, completion: nil)
    }
    
    func goToSignUp() {
        let signUp = viewController?.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        signUp.isSignup = true
        viewController?.navigationController?.pushViewController(signUp, animated: true)
    }
    
    func goToCart(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
