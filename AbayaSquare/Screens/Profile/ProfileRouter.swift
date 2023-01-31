//
//  ProfileRouter.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import Foundation

class ProfileRouter {
    
    weak var viewController: ProfileVC?
    
    var type: AboutCases = .About
    
    func goToLogin(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToUserProfile(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToMyOrders(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "OrdersVC") as! OrdersVC
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToWallet(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "WalletVC") as! WalletVC
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToMyAddresses(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "AddressesVC") as! AddressesVC
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToDiscountCodes(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "DiscountCodesVC") as! DiscountCodesVC
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToFavourite(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "FavouriteVC") as! FavouriteVC
        vc.hidesBottomBarWhenPushed = true
        vc.isFromProfile = 1
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToNotifications(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToAbout(){
        let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
        vc.hidesBottomBarWhenPushed = true
        vc.type = type
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func logout() {
        viewController?.showSignOutAlert { [weak self] in
            User.currentUser = nil
            UserDefaultsManager.token = nil
            self?.logoutUser { _ in }
            self?.viewController?.otherTV.reloadData()
            CoreDataManager.emptyBasket()
            self?.viewController?.tabBarController?.selectedIndex = 2
            NotificationCenter.default.post(name: .UserDidAddProduct, object: nil)
            NotificationCenter.default.post(name: .UserDidLogout, object: nil)
        }
    }
    
    func deleteAccount(){
        viewController?.deleteAccountAlert {
            self.deleteAccount { _ in }
            self.viewController?.otherTV.reloadData()
            CoreDataManager.emptyBasket()
            User.currentUser = nil
            UserDefaultsManager.token = nil
            let vc = self.viewController?.storyboard?.instantiateViewController(withIdentifier: "IntroVC") as! IntroVC
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.isNavigationBarHidden = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
            NotificationCenter.default.post(name: .diddeleteAccount, object: nil)
            
        }
    }
    
    func logoutUser(onComplete: @escaping onComplete<LogoutModel.Response>){
        API.shared.startAPI(endPoint: .logoutUser, req: LogoutModel.Request(), onComplete: onComplete)
    }
    
    
    func deleteAccount(onComplete: @escaping onComplete<DeleteAccountModel.Response>){
        API.shared.startAPI(endPoint: .deleteAccount, req: DeleteAccountModel.Request(), onComplete: onComplete)
    }
}
