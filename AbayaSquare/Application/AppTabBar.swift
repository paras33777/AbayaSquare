//
//  AppTabBar.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/31/21.
//

import UIKit
import Kingfisher

class AppTabBar: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        updateProductCounts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateProductCounts()
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProductCounts), name: .UserDidAddProduct, object: nil)
    }
    
    @objc func updateProductCounts(){
        if CoreDataManager.getTotalCount() == 0 {
            self.viewControllers![3].tabBarItem.badgeValue = nil
        } else {
            self.viewControllers![3].tabBarItem.badgeValue = String(CoreDataManager.getTotalCount())
        }
    }
}
