//
//  SceneDelegate.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/23/21.
//

import UIKit
import FirebaseDynamicLinks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
//    var appState = AppState()
//    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        window?.configureRootViewController()
        //        self.handle(connectionOptions.urlContexts)
        if let tabBarController = self.window!.rootViewController as? AppTabBar {
            tabBarController.selectedIndex = 2
        }
        
        guard let userActivity = connectionOptions.userActivities.first(where: { $0.webpageURL != nil }) else { return }
        if let incomingUrl = userActivity.webpageURL {
            _ = DynamicLinks.dynamicLinks().handleUniversalLink(incomingUrl) { (dynamicLink, error) in
                guard error == nil else {
                    print("error: \(error!.localizedDescription)")
                    MainHelper.shared.showErrorMessage(responseMessage: error?.localizedDescription ?? "")
                    return
                }
                if let dynamicLink = dynamicLink {
                    self.handelDynamicLinks(dynamicLink)
                }
            }
        }
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
       
    }
    
    
    func sceneWillResignActive(_ scene: UIScene) {
 
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
 
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
     
    }
    
    func handelDynamicLinks(_ dynamicLink: DynamicLink){
        guard let url = dynamicLink.url else {
            print("error the dynamicLink")
            return
        }
        
        print("the dynamicLink is: \(url.absoluteString)")
        
        guard (dynamicLink.matchType == .unique || dynamicLink.matchType == .default ) else {
            print("some error")
            return
        }
        
        // deal the url:
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else {return}
        
        print("components.path: \(components.path)")
        print("queryItems: \(queryItems)")
        if components.path == "/api/v1/get-product-details" {
            if let productIDQueryItem = queryItems.first(where: {$0.name == "productId"}) {
                print("go to product details")
                guard let productId = productIDQueryItem.value else {return}
                window =  (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).window
                let tabBarVC = self.window?.rootViewController as! UITabBarController
                let navCV = tabBarVC.selectedViewController as? UINavigationController
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
                vc.viewModel.productId = productId.toInt()
                vc.hidesBottomBarWhenPushed = true
                navCV?.pushViewController(vc, animated: true)
                
            }
        }
        
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity){
        if let incomingUrl = userActivity.webpageURL {
            _ = DynamicLinks.dynamicLinks().handleUniversalLink(incomingUrl) { (dynamicLink, error) in
                guard error == nil else {
                    print("error: \(String(describing: error?.localizedDescription))")
                    MainHelper.shared.showErrorMessage(responseMessage: error?.localizedDescription ?? "")
                    return
                }
                if let dynamicLink = dynamicLink {
                    self.handelDynamicLinks(dynamicLink)
                }
            }
        }
    }

//    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//        print(URLContexts.first!.url)
//        if URLContexts.first!.url.absoluteString.contains("tamara://checkout/success") {
//            appState.orderSuccessed = true
//            appState.currentPage = AppPages.Success
//        } else if URLContexts.first!.url.absoluteString.contains("tamara://checkout/failure") {
//            appState.orderSuccessed = false
//            appState.currentPage = AppPages.Success
//        } else {
//            
//            appState.currentPage = AppPages.Info
//        }
//    }
        
    
}

