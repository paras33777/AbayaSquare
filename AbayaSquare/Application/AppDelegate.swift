//
//  AppDelegate.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/23/21.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging
import FirebaseCore
import Siren
import TamaraSDK
import Kingfisher

@main
class AppDelegate: UIResponder,UIApplicationDelegate{

    static var deviceKey = ""
    var window: UIWindow?
    var notificationDelegate = NotificationDelegate()
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseOptions.defaultOptions()?.deepLinkURLScheme = "abayasquare"
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        
        UNUserNotificationCenter.current().delegate = self
        // 2
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions) { _, _  in }
        // 3
        application.registerForRemoteNotifications()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        NetworkReachability.shared.startMonitoring()
        UIFont.overrideInitialize()
        UIViewController.swizzle()
        setupLanguage()
//        setupNotification()

        setupIQKeyboardManager()
        L102Localizer.DoTheMagic()
        Configuration.configure()
        window?.configureRootViewController()
        AppAppearance.setupAppearance()
        AppAppearance.setupTabBarAppearance()
        
       
        
        
//        Messaging.messaging().delegate = self
        
//        if #available(iOS 10.0, *) {
//                   // For iOS 10 display notification (sent via APNS)
//                   UNUserNotificationCenter.current().delegate = self
//
//                   let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//                   UNUserNotificationCenter.current().requestAuthorization(
//                       options: authOptions,
//                       completionHandler: {_,_  in })
//               } else {
//                   let settings: UIUserNotificationSettings =
//                       UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//                   application.registerUserNotificationSettings(settings)
//               }
//
//               Messaging.messaging().token { token, error in
//                   if let error = error {
//                       print("Error fetching FCM registration token: \(error)")
//                   } else if let token = token {
//                       print("FCM registration token: \(token)")
////                       Cookies.saveDeviceToken(token: token)
////                       appDeviceToken = token
//                       AppDelegate.deviceKey = token
//                       API.shared.startAPI(endPoint: .updateDvieceKey, req: DeviceKeyModel.Request()) {(result: Response<DeviceKeyModel.Response>) in
//                           switch result {
//                           case .success(let response) : print(response.responseMessage ?? "")
//                               case .failure(_): break
//                           }
//                       }
//                       print("Device Key: \(token)")
////                       print("TOKEN-------9094432701B20B762EA1E04C28719622762F9E2DCDE0AEA1149267D3F337724D : \(token)")
//                   }
//               }
    
//        registerForPushNotifications()
        

        
        
        
        UserDefaultsManager.coupon = nil
//        SDWebImageManager.shared.imageCache
//        deleteOldFiles(completionBlock: nil)
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
//        fileprivate func setupKingfisherSettings() {
//        ImageCache.default.clearMemoryCache()
//            }
//        Siren.shared.wail()
//        
//        if L102Language.isRTL {
//            Siren.shared.presentationManager = PresentationManager(forceLanguageLocalization: .arabic)
//        } else {
//            Siren.shared.presentationManager = PresentationManager(forceLanguageLocalization: .english)
//        }
//        Siren.shared.rulesManager = RulesManager(globalRules: Rules(promptFrequency: .immediately,
//                                                                    forAlertType: .option))
        return true
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                    willPresent notification: UNNotification,
//                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//            let userInfo = notification.request.content.userInfo
//            print(userInfo)
//            print("Notification Present ---->")
//            NotificationCenter.default.post(name: Notification.Name("NotificationForNotificationCount"), object: nil)
//    //        UIApplication.shared.applicationIconBadgeNumber = 0
//            UNUserNotificationCenter.current().requestAuthorization(options: .badge) { (granted, error) in
//                if error != nil {
//                    UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1;
//
//                }
//            }
//            completionHandler([.alert, .sound, .badge])
//        }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
////            var window: UIWindow?
////            UIApplication.shared.applicationIconBadgeNumber = 0
////        //    guard let windowScene = (scene as? UIWindowScene) else { return }
////            if UserDefaults.standard.string(forKey: UserDefaultKey.kUserToken) == ""{
////    //            let HomeDetailVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
////                let HomeDetailVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
////               let navC = UINavigationController(rootViewController: HomeDetailVC)
////               navC.navigationBar.isHidden = true
////               UIApplication.shared.windows.first?.rootViewController = navC
////               UIApplication.shared.windows.first?.makeKeyAndVisible()
////
////        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
////        //        guard let rootVC = storyboard.instantiateViewController(identifier: "WelcomeVC") as? WelcomeVC else {
////        //            print("ViewController not found")
////        //            return
////        //        }
////        //        let rootNC = UINavigationController(rootViewController: rootVC)
////        //        rootVC.navigationController?.navigationBar.isHidden = true
////        //       window?.rootViewController = rootNC
////        //        window?.makeKeyAndVisible()
////            }else{
////                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierForNotficationVC"), object: nil)
////                    let HomeDetailVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
////
////                   let navC = UINavigationController(rootViewController: HomeDetailVC)
////                   navC.navigationBar.isHidden = true
////                   UIApplication.shared.windows.first?.rootViewController = navC
////                   UIApplication.shared.windows.first?.makeKeyAndVisible()
////
////
////            }
////
////        //
////        //    guard let _ = (scene as? UIWindowScene) else { return }
//
        
 
    func applicationDidBecomeActive(_ application: UIApplication) {
        if L102Language.isRTL {
            Siren.shared.presentationManager = PresentationManager(forceLanguageLocalization: .arabic)
        } else {
            Siren.shared.presentationManager = PresentationManager(forceLanguageLocalization: .english)
        }
        Siren.shared.rulesManager = RulesManager(globalRules: Rules(promptFrequency: .immediately,
                                                                    forAlertType: .option))
        Siren.shared.wail()
    }
    
    
    func setupLanguage() {
        let isSetLanguageBefore = UserDefaults.standard.bool(forKey: "isSetLanguageBefore")
        if !isSetLanguageBefore {
            L102Language.setAppleLAnguageTo(lang: "ar")
            UserDefaults.standard.set(true, forKey: "isSetLanguageBefore")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
    
    func setupIQKeyboardManager(){
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.disabledDistanceHandlingClasses = [ActivateVC.self]
        IQKeyboardManager.shared.disabledToolbarClasses = [ActivateVC.self]
    }
    
    func setupNotification() {
//        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = notificationDelegate
        let center = UNUserNotificationCenter.current()
        center.delegate = notificationDelegate
        center.requestAuthorization(options: [.sound, .alert, .badge]) { granted, error in
            guard error == nil else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//           print("RECEIVED NOTIFICATION")
//        }
   
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
       print("Failed to register: \(error)")
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler:
    @escaping (UNNotificationPresentationOptions) -> Void
  ) {
      if #available(iOS 14.0, *) {
          completionHandler([[.banner, .sound]])
      } else {
          // Fallback on earlier versions
      }
  }
  func userNotificationCenter(_ center: UNUserNotificationCenter,didReceive response: UNNotificationResponse,withCompletionHandler completionHandler: @escaping() -> Void) {
    completionHandler()
  }
    func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging,didReceiveRegistrationToken fcmToken: String?) {
   let tokenDict = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"),object: nil,userInfo: tokenDict)
      print(tokenDict)
      AppDelegate.deviceKey = fcmToken ?? ""
              API.shared.startAPI(endPoint: .updateDvieceKey, req: DeviceKeyModel.Request()) {(result: Response<DeviceKeyModel.Response>) in
                  switch result {
                  case .success(let response) : print(response.responseMessage ?? "")
                      case .failure(_): break
                  }
              }
              print("Device Key: \(fcmToken.emptyIfNull)")
      print(fcmToken)
//      UserDefaults.standard.setValue(deviceToken, forKey: UserDefaultKey.fcmToken)
//      Cookies.saveUserDeviceToken(fcmToken: deviceToken)
  }
}

//extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate  {
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        AppDelegate.deviceKey = fcmToken ?? ""
//        API.shared.startAPI(endPoint: .updateDvieceKey, req: DeviceKeyModel.Request()) {(result: Response<DeviceKeyModel.Response>) in
//            switch result {
//            case .success(let response) : print(response.responseMessage ?? "")
//                case .failure(_): break
//            }
//        }
//        print("Device Key: \(fcmToken.emptyIfNull)")
//    }
//
//
//
//}




extension UICollectionView {
  var visibleCurrentCellIndexPath: IndexPath? {
    for cell in self.visibleCells {
      let indexPath = self.indexPath(for: cell)
      return indexPath
    }
    
    return nil
  }
}
