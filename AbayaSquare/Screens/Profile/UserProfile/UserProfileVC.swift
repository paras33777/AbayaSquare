//
//  UserProfileVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/25/21.
//

import UIKit

class UserProfileVC: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var prifixButton: UIButton!
    
    let viewModel = AuthViewModel()
    let router = AuthRouter()
    var mobilePrifix = "966"
    var newImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile".localized
        setupDetails()
        router.viewController = self
        if User.currentUser?.mobile == nil {
            prifixButton.setTitle(UserDefaultsManager.config?.data?.countriesPhoneList?.first, for: .normal)
        } else {
            let mobile = User.currentUser?.mobile ?? ""
            mobilePrifix = String(mobile.prefix(3))
            prifixButton.setTitle(mobilePrifix, for: .normal)
        }
    }
    
    @IBAction func didTapAddImage(_ sender: Any) {
        getAccess(on: self)
    }
    
    @IBAction func didTapSaveProfile(_ sender: UIButton) {
        var request = AuthModel.UpdatePrfile()
        nameTF.text.emptyIfNull.isEmpty ? (request.name = nil) : (request.name = nameTF.text)
        emailTF.text.emptyIfNull.isEmpty ? (request.email = nil) : (request.email = emailTF.text)
        mobileNumberTF.text.emptyIfNull.isEmpty ? (request.mobile = nil) : (request.mobile = "\(mobilePrifix)\(mobileNumberTF.text.emptyIfNull)")
        
        if let image = newImage {
            request.avatar = image.jpegData(compressionQuality: 0.3)
        }
        sender.showSpinner(spinnerColor: .white)
        print(request)

        viewModel.updateProfile(request: request) {result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    @IBAction func didTapChangePrifix(_ sender: UIButton) {
        let dropDown = showDropDownMenu(button: sender)
        dropDown.dataSource = UserDefaultsManager.config?.data?.countriesPhoneList ?? [""]
        dropDown.show()
        dropDown.selectionAction = { [self] index, item in
            sender.setTitle(item, for: .normal)
            mobilePrifix = item
        }
    }
    
    func onSuccess(_ response: AuthModel.Response){
        removeSpinner()
        if let errors = response.errors {
            MainHelper.shared.showErrorMessage(errors: errors)
            return
        }
        
        if response.status == false {
            MainHelper.shared.showErrorMessage(responseMessage: response.responseMessage.emptyIfNull)
            return
        }
        if let user = response.customer {
            if user.status == 0 {
                User.currentUser = nil
                UserDefaultsManager.token = nil
                if UserDefaultsManager.isMobile == 1 {
                    UserDefaults.standard.setValue(user.mobile, forKey: "mobile")
                } else {
                    UserDefaults.standard.setValue(user.email, forKey: "email")
                }
                router.goToActivate()
                return
            } else {
                User.currentUser = user
                navigationController?.popViewController(animated: true)
                MainHelper.shared.showSuccessMessage(responseMessage: response.responseMessage.emptyIfNull)
                NotificationCenter.default.post(name: .UserDidUpdateProfile, object: nil)
            }
        }
    }
}

extension UserProfileVC {
    func setupDetails(){
        guard let user = User.currentUser else {return}
        nameTF.text = user.name
        let mobile = String(user.mobile?.suffix(9) ?? "" )
        mobileNumberTF.text = mobile
        emailTF.text = user.email
        userImage.setImage(url: user.avatarUrl)
        userImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeImage))
        userImage.addGestureRecognizer(tap)
    }
    
    @objc func changeImage(){
        getAccess(on: self)
    }
}

extension UserProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[.editedImage] as? UIImage
        userImage.image = image
        newImage = image
    }
}

