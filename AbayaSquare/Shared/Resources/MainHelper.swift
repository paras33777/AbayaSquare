
import UIKit
import SwiftMessages

class MainHelper {
    static let shared = MainHelper()
    
    private init() {}
    
    var currency: String {
        if L102Language.isRTL {
            return UserDefaultsManager.config?.data?.settings?.currencyAr ?? ""
        } else {
            return UserDefaultsManager.config?.data?.settings?.currencyEn ?? ""
        }
    }
    
    public func showErrorMessage(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessage(error)
        }
    }
    
    public func showErrorMessage(responseMessage: String) {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessage(responseMessage: responseMessage)
        }
    }
    
    public func showErrorMessage(errors: [ResponseError]) {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessage(errors: errors)
        }
    }
    
    public func showSuccessMessage(responseMessage: String) {
        DispatchQueue.main.async { [weak self] in
            self?.successMessage(responseMessage: responseMessage)
        }
    }
    
    public func showNoticeMessage(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.noticMessage(title: "Notice".localized, noticBody: message)
        }
    }
    
    public func showNoticeWithButton(message: String, buttonTitle: String? = nil, buttonAction: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.noticeWithButtonMessage(title: "Notice".localized, noticBody: message, buttonTitle: buttonTitle, buttonAction: buttonAction)
        }
    }
    
    public func showErrorWithButton(message: String, buttonTitle: String? = nil, buttonAction: ((UIButton) -> Void)? = nil) {
        errorWithButtonMessage(message: message, buttonTitle: buttonTitle, buttonAction: buttonAction)
    }
    
    private func noticeWithButtonMessage(title: String, noticBody: String, buttonTitle: String? = nil, buttonAction: (() -> Void)? = nil) {
        let Noticview = MessageView.viewFromNib(layout: .centeredView)
        
        Noticview.configureTheme(.warning)
        Noticview.configureContent(title: title, body: noticBody)
        Noticview.button?.isHidden = true
        
        Noticview.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        Noticview.bodyLabel?.font = UIFont.systemFont(ofSize: 14)
        
        if let title = buttonTitle, let _ = buttonAction {
            Noticview.button?.isHidden = false
            Noticview.button?.setTitle(title, for: .normal)
            Noticview.button?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            Noticview.buttonTapHandler = { _ in
                SwiftMessages.hideAll()
            }
        }
        var config = SwiftMessages.Config()
        config.presentationContext = .window(windowLevel: .normal)
        config.duration = .forever
        SwiftMessages.show(config: config, view: Noticview)
    }
    
    private func errorWithButtonMessage(message: String, buttonTitle: String? = nil, buttonAction: ((UIButton) -> Void)? = nil) {
        let Noticview = MessageView.viewFromNib(layout: .centeredView)
        
        Noticview.configureTheme(.error)
        Noticview.configureContent(title: "Error".localized, body: message)
        Noticview.button?.isHidden = true
        
        Noticview.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        Noticview.bodyLabel?.font = UIFont.systemFont(ofSize: 14)
        
        if let title = buttonTitle, let _ = buttonAction {
            Noticview.button?.isHidden = false
            Noticview.button?.setTitle(title, for: .normal)
            Noticview.button?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            Noticview.buttonTapHandler = buttonAction
        }
        var config = SwiftMessages.Config()
        config.presentationContext = .window(windowLevel: .normal)
        config.duration = .forever
        SwiftMessages.show(config: config, view: Noticview)
    }
    private func errorMessage(_ error: Error) {
        let errorView = MessageView.viewFromNib(layout: .centeredView)
        
        errorView.button?.isHidden = true
        errorView.titleLabel?.isHidden = true
        errorView.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        errorView.bodyLabel?.font = UIFont.systemFont(ofSize: 16)
        errorView.configureTheme(.error)
        
        errorView.configureContent(title: "Error".localized,
                                   body: error.localizedDescription,
                                   iconImage: nil,
                                   iconText: nil,
                                   buttonImage: nil,
                                   buttonTitle: NSLocalizedString("Hide", comment: ""),
                                   buttonTapHandler: { _ in SwiftMessages.hide() })
        
        
        var config = SwiftMessages.Config()
        config.presentationContext = .window(windowLevel: .normal)
        
        SwiftMessages.show(config: config, view: errorView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            SwiftMessages.hideAll()
        }
    }
    
    private func errorMessage(responseMessage: String) {
        let errorView = MessageView.viewFromNib(layout: .centeredView)
        
        errorView.button?.isHidden = true
        errorView.titleLabel?.isHidden = true
        errorView.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        errorView.bodyLabel?.font = UIFont.systemFont(ofSize: 16)
        errorView.configureTheme(.error)
        
        errorView.configureContent(title: "Error".localized,
                                   body: responseMessage,
                                   iconImage: nil,
                                   iconText: nil,
                                   buttonImage: nil,
                                   buttonTitle: NSLocalizedString("Hide", comment: ""),
                                   buttonTapHandler: { _ in SwiftMessages.hide() })
        
        
        var config = SwiftMessages.Config()
        config.presentationContext = .window(windowLevel: .normal)
        
        SwiftMessages.show(config: config, view: errorView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            SwiftMessages.hideAll()
        }
    }
    
    private func errorMessage(errors: [ResponseError]) {
        let errorView = MessageView.viewFromNib(layout: .centeredView)
        
        errorView.button?.isHidden = true
        errorView.titleLabel?.isHidden = true
        errorView.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        errorView.bodyLabel?.font = UIFont.systemFont(ofSize: 16)
        errorView.configureTheme(.error)
        
        let errorBody = parseErrorMessage(errors: errors)
        
        errorView.configureContent(title: nil,
                                   body: errorBody,
                                   iconImage: nil,
                                   iconText: nil,
                                   buttonImage: nil,
                                   buttonTitle: NSLocalizedString("Hide", comment: ""),
                                   buttonTapHandler: { _ in SwiftMessages.hide() })
        
        var config = SwiftMessages.Config()
        config.presentationContext = .window(windowLevel: .normal)
        
        SwiftMessages.show(config: config, view: errorView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            SwiftMessages.hideAll()
        }
    }
    
    private func successMessage(responseMessage: String) {
        let Successview = MessageView.viewFromNib(layout: .centeredView)
        
        Successview.configureTheme(.success)
        Successview.configureContent(title: "Success".localized , body: responseMessage)
        Successview.button?.isHidden = true
        Successview.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        Successview.bodyLabel?.font = UIFont.systemFont(ofSize: 16)
        
        var config = SwiftMessages.Config()
        config.presentationContext = .window(windowLevel: .normal)
        
        SwiftMessages.show(config: config, view: Successview)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            SwiftMessages.hideAll()
        }
    }
    
    private func noticMessage(title: String, noticBody: String) {
        let Noticview = MessageView.viewFromNib(layout: .centeredView)
        
        Noticview.configureTheme(.warning)
        Noticview.configureContent(title: title, body: noticBody)
        Noticview.button?.isHidden = true
        Noticview.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        Noticview.bodyLabel?.font = UIFont.systemFont(ofSize: 16)
        
        var config = SwiftMessages.Config()
        config.presentationContext = .window(windowLevel: .normal)
        
        SwiftMessages.show(config: config, view: Noticview)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            SwiftMessages.hideAll()
        }
    }
    
    private func parseErrorMessage(errors: [ResponseError]) -> String {
        var msg = ""
    
        for error in errors {
            msg += "\(error.error)\n"
        }
        
        return msg
    }
    
    public func changeLanguageToEnglish(){
        guard L102Language.isRTL else { return }
        
        let transition: UIView.AnimationOptions = .transitionFlipFromRight
        L102Language.setAppleLAnguageTo(lang: "en")
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        
        let mainWindow: UIWindow
        
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            let sd: SceneDelegate = (scene?.delegate as? SceneDelegate)!
            mainWindow = sd.window!
        } else {
            mainWindow = ((UIApplication.shared.delegate?.window)!)!
        }
        
        UIView.transition(with: mainWindow, duration: 0.55001, options: transition) {
            if #available(iOS 13.0, *) {
                let scene = UIApplication.shared.connectedScenes.first
                let sd: SceneDelegate = (scene?.delegate as? SceneDelegate)!
                sd.window?.configureRootViewController()
                let vc = sd.window?.rootViewController as? AppTabBar
                vc?.selectedIndex = 2
            } else {
                (UIApplication.shared.delegate as! AppDelegate).window?.configureRootViewController()
            }
        }
    }

    public func changeLanguageToArabic(){
        guard !L102Language.isRTL else { return }

        let transition: UIView.AnimationOptions = .transitionFlipFromLeft
        L102Language.setAppleLAnguageTo(lang: "ar")
        UIView.appearance().semanticContentAttribute = .forceRightToLeft

        let mainWindow: UIWindow

        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            let sd: SceneDelegate = ((scene?.delegate as? SceneDelegate)!)
            mainWindow = sd.window!
        } else {
            mainWindow = ((UIApplication.shared.delegate?.window)!)!
        }

        UIView.transition(with: mainWindow, duration: 0.55001, options: transition) {
            if #available(iOS 13.0, *) {
                let scene = UIApplication.shared.connectedScenes.first
                let sd: SceneDelegate = ((scene?.delegate as? SceneDelegate)!)
                sd.window?.configureRootViewController()
                let vc = sd.window?.rootViewController as? AppTabBar
                vc?.selectedIndex = 2
            } else {
                (UIApplication.shared.delegate as! AppDelegate).window?.configureRootViewController()
            }
        }
    }
    
    func openEmail(mail:String){
        let appURL = URL(string: "mailto:\(mail )")!
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL)
            }
        } else {
            noticMessage(title: "Notice".localized, noticBody: "You don't have Email application, you need to install it".localized)
        }
    }
    
    func makeCall(_ phone: String) {
        guard let number = URL(string: "telprompt://\(phone)") else { return }
        UIApplication.shared.open(number)
    }
    
    func openWhatsapp(_ phone: String) {
        let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phone)")!
        
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else {
            MainHelper.shared.showNoticeMessage(message: "Please Install Whatsapp".localized)
        }

    }
    
    func openInstagram(_ insta: String) {
        let appURL = URL(string: "instagram://user?username=\(insta)")!
        
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else {
            MainHelper.shared.showNoticeMessage(message: "Please Install Instagram".localized)
        }
    }
    
    func openSnapchat(_ snap: String) {
        let appURL = URL(string: snap)!
        
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else {
            MainHelper.shared.showNoticeMessage(message: "Please Install Snapchat".localized)
        }
    }
    
    func appLanguage() -> String {
        return L102Language.currentAppleLanguage()
    }
    
    func open(_ url: String?) {
        guard let url = URL(string: url ?? "") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
