
import Foundation
import UIKit
import Photos
import DropDown

var vSpinner : UIView?

extension UIViewController {
    
    func showDropDownMenu(button: UIButton) -> DropDown {
        let dropDown = DropDown()
        dropDown.anchorView = button
        dropDown.direction = .bottom
        dropDown.semanticContentAttribute = .forceLeftToRight
        dropDown.textFont = UIFont.systemFont(ofSize: 14)
        dropDown.width = button.frame.width
        dropDown.backgroundColor = .white
        dropDown.cornerRadius = 10
        dropDown.textColor = .black
        dropDown.selectionBackgroundColor = .lightGray
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        return dropDown
    }
    
    func removeSpinner() {
        vSpinner?.removeFromSuperview()
        vSpinner = nil
    }
    
    func onFailure(_ error: APIError) {
        if case let .error(message) = error {
            if message == "تسجيل دخول غير مصرح به"{
                comingFrom = "cart"
                let vc = self.navigationController?.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                
            }
            MainHelper.shared.showErrorMessage(responseMessage: message)
        } else if case let .errors(messages) = error {
            MainHelper.shared.showErrorMessage(errors: messages)
        } else {
            MainHelper.shared.showErrorMessage(error)
        }
        
        removeSpinner()
        view.subviews.forEach { ($0 as? UIScrollView)?.refreshControl?.endRefreshing() }
    }
    
    func showSignOutAlert(signOutAction: @escaping () -> Void) {
        let alert = UIAlertController(title: "Logout".localized, message: "Are You Sure Want To Logout?".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .default))
        alert.addAction(UIAlertAction(title: "Logout".localized, style: .default) { _ in
            signOutAction()
        })
        present(alert, animated: true, completion: nil)
    }
    
    func deleteAccountAlert(deleteAccountAcction: @escaping () -> Void) {
        let alert = UIAlertController(title: "Delete Account".localized, message: "Are You Sure Want To Delete Account?".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .default))
        alert.addAction(UIAlertAction(title: "Delete".localized, style: .default) { _ in
            deleteAccountAcction()
        })
        present(alert, animated: true, completion: nil)
    }
    
    
    func presentBottomSheet(_ vc: UIViewController) {
        vc.modalPresentationStyle = .overCurrentContext
        if let tabbar = tabBarController {
            tabbar.present(vc, animated: false, completion: nil)
        } else if let nav = navigationController {
            nav.present(vc, animated: false, completion: nil)
        } else {
            present(vc, animated: false, completion: nil)
        }
    }
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func alertWithCancel(title: String, message:String, OkAction: String = "OK".localized,cancelAction: String = "Cancel".localized, completion: ((UIAlertAction) -> Void)? = nil ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: OkAction, style: .default, handler: completion))
        alert.addAction(UIAlertAction(title: cancelAction, style: .cancel))
        present(alert, animated: true, completion: nil)
    }
    
    func getAccess<T>(on viewController: T) where T: UIViewController, T: UIImagePickerControllerDelegate, T: UINavigationControllerDelegate {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized            : pickImage(delegate: viewController)
        case .denied, .restricted   : alert(title: "Error Access Photo Library".localized, message: "Go To Settings And Allow the app to Access Photo Library".localized)
        case .notDetermined         : PHPhotoLibrary.requestAuthorization {
            if $0 == .authorized {
                DispatchQueue.main.async {
                    self.getAccess(on: viewController)
                }
            }
        }
        default: return
        }
    }
    
    func pickImage<T>(delegate: T) where T: UIViewController, T: UIImagePickerControllerDelegate, T: UINavigationControllerDelegate{
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = delegate
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func setCurrentBackButton(title: String) {
        guard let vcCount = self.navigationController?.viewControllers.count else {
            return
        }
        let priorVCPosition = vcCount - 2
        guard priorVCPosition >= 0 else {
            return
        }
        self.navigationController?.viewControllers[priorVCPosition].navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: nil)
    }
}

extension UINavigationController {

  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
      popToViewController(vc, animated: animated)
    }
  }

  func popViewControllers(viewsToPop: Int, animated: Bool = true) {
    if viewControllers.count > viewsToPop {
      let vc = viewControllers[viewControllers.count - viewsToPop - 1]
      popToViewController(vc, animated: animated)
    }
  }
}
