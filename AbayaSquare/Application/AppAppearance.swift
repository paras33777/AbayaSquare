//
//  AppAppearance.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/25/21.
//

import Foundation
import UIKit

final class AppAppearance {
    static func setupAppearance() {
        UINavigationBar.appearance().tintColor = UIColor("#7C7160")
        UINavigationBar.appearance().isTranslucent = false
        let navigationTitleTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor("#333333"), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]
        let navigationBarAppearance =  UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = UIColor("#E4D7C4").withAlphaComponent(0.4)
        navigationBarAppearance.shadowColor = .none
        navigationBarAppearance.titleTextAttributes = navigationTitleTextAttribute
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
    
    static func setupTabBarAppearance() {
        let tabBarItemAppearance = UITabBarItemAppearance()
        tabBarItemAppearance.normal.iconColor = UIColor("#999999")
        tabBarItemAppearance.selected.iconColor = UIColor("#7C7160")
        
        tabBarItemAppearance.normal.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 10),
                                                           .foregroundColor: UIColor("#999999")]
        
        tabBarItemAppearance.selected.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 10),
                                                             .foregroundColor: UIColor("#7C7160")]
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        appearance.shadowImage = nil
        appearance.backgroundImage = nil
        appearance.compactInlineLayoutAppearance = tabBarItemAppearance
        appearance.inlineLayoutAppearance = tabBarItemAppearance
        appearance.stackedLayoutAppearance = tabBarItemAppearance
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) { UITabBar.appearance().scrollEdgeAppearance = appearance }
        
        if #available(iOS 15.0, *) { UITableView.appearance().sectionHeaderTopPadding = 0 }
    }
}


class myNav: UINavigationController {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .darkContent
    }
}

private let swizzling: (UIViewController.Type, Selector, Selector) -> Void = { forClass, originalSelector, swizzledSelector in
    if let originalMethod = class_getInstanceMethod(forClass, originalSelector), let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector) {
        let didAddMethod = class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        if didAddMethod {
            class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}

extension UIViewController {
    static func swizzle() {
        let originalSelector1 = #selector(viewDidLoad)
        let swizzledSelector1 = #selector(swizzled_viewDidLoad)
        swizzling(UIViewController.self, originalSelector1, swizzledSelector1)
    }
    
    @objc open func swizzled_viewDidLoad() {
        if let _ = navigationController {
            if #available(iOS 14.0, *) {
                navigationItem.backButtonDisplayMode = .minimal
            } else {
                navigationItem.backButtonTitle = ""
            }
        }
        swizzled_viewDidLoad()
    }
}
