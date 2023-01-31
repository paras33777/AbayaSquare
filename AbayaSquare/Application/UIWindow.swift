//
//  UIWindow.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/27/21.
//

import Foundation
import UIKit
import Siren

extension UIWindow {
    func configureRootViewController() {
        if UserDefaultsManager.isFirstLaunch {
            let vc: UIViewController
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IntroVC")
            rootViewController = vc
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Root")
            rootViewController = vc
        }
        makeKeyAndVisible()
        Siren.shared.wail()
        
        if L102Language.isRTL {
            Siren.shared.presentationManager = PresentationManager(forceLanguageLocalization: .arabic)
        } else {
            Siren.shared.presentationManager = PresentationManager(forceLanguageLocalization: .english)
        }
        Siren.shared.rulesManager = RulesManager(globalRules: Rules(promptFrequency: .immediately,
                                                                    forAlertType: .option))
    }
}
