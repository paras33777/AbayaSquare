//
//  NotificationDelegate.swift
//  GramApp
//
//  Created by Ayman  on 2/18/21.
//

import Foundation
import UserNotifications
import UIKit

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    
    var window: UIWindow?
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        completionHandler([.alert, .badge, .sound])
        let userInfoString = (userInfo["gcm.notification.data"] as! String)
//        print(userInfoString)
        let data = userInfoString.data(using: .utf8)!
        if userInfoString.contains("status") {
            do {
//                print("userInfoString: \(userInfoString)")
                let model = try JSONDecoder().decode(StatusNotification.self, from: data)
                User.currentUser?.status = model.status
            }catch {
                print(error)
            }
        }
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            
            let userInfo = response.notification.request.content.userInfo
            let string = (userInfo["gcm.notification.data"] as! String)
            
            print("notification click string : \(string)")
            
            if string.contains("order_id") {
                let data = string.data(using: .utf8)!
                var orderId = 0
                do {
                    let model = try JSONDecoder().decode(OrderIdNotification.self, from: data)
                    orderId = model.id
                } catch {
                    print(error)
                }
                
                window =  (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).window
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "OrderDetailsVC") as? OrderDetailsVC{
                    vc.viewModel.orderId = orderId
                    vc.hidesBottomBarWhenPushed = true
                    let tabBarVC = window?.rootViewController as? AppTabBar
                    let navVC = tabBarVC?.selectedViewController as? UINavigationController
                    navVC?.pushViewController(vc, animated: true)
                }
            }
        default:
            print("default")
        }
        completionHandler()
    }
}



struct OrderIdNotification: Codable {
    let id: Int
    
    private enum CodingKeys: String, CodingKey {
        case id = "order_id"
    }
}

struct StatusNotification: Codable {
    let status: Int
    
    private enum CodingKeys: String, CodingKey {
        case status = "status"
    }
}
