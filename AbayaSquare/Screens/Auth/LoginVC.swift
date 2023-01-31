//
//  LoginVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import UIKit
import IBAnimatable
import SwiftMessages

class LoginVC: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var fieldView: AnimatableView!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var policyButton: UIButton!
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var errorLB: UILabel!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var fileldImageView: UIImageView!
    @IBOutlet weak var mobilePrefixView: UIView!
    @IBOutlet weak var smsLB: UILabel!
    @IBOutlet weak var prifixLB: UILabel!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var nameErrorImage: UIImageView!

    private let router = AuthRouter()
    private let viewModel = AuthViewModel()
    var loginCase: LoginCases = .Mobile
    var isFromIntro = 0
    var isSignup = false
    var request = AuthModel.LoginRegister()
    
    override func viewWillAppear(_ animated: Bool) {
        if isFromIntro == 1 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else if isSignup {
            title = "Register".localized
            nameView.isHidden = false
            nameTextField.isHidden = false
        } else {
            title = "Login".localized
        }
        termsButton.underline(font: .boldSystemFont(ofSize: 14))
        policyButton.underline(font: .boldSystemFont(ofSize: 14))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaultsManager.isMobile = 1
        mobileTF.keyboardType = .asciiCapableNumberPad
        router.viewController = self
        if isFromIntro == 1 {
            closeButton.isHidden = false
        } else {
            closeButton.isHidden = true
        }
        
        prifixLB.text = UserDefaultsManager.config?.data?.countriesPhoneList?.first
        request.mobileCode = UserDefaultsManager.config?.data?.countriesPhoneList?.first
        
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapChangeLanguage(_ sender: Any) {
        if L102Language.isRTL {
            MainHelper.shared.changeLanguageToEnglish()
        } else {
            MainHelper.shared.changeLanguageToArabic()
        }
    }
    
    @IBAction func didTapChangePrifix(_ sender: UIButton) {
        let dropDown = showDropDownMenu(button: sender)
        dropDown.dataSource = UserDefaultsManager.config?.data?.countriesPhoneList ?? [""]
        dropDown.show()
        dropDown.selectionAction = { [self] index, item in
            prifixLB.text = item
            request.mobileCode = item
        }
    }
    
    @IBAction func didTapSwitch(_ sender: Any) {
        errorLB.isHidden = true
        errorImage.isHidden = true
        nameErrorLabel.isHidden = true
        nameErrorImage.isHidden = true
        mobileTF.text = nil
        mobileTF.resignFirstResponder()
        switch loginCase {
        case .Mobile:
            loginCase = .Email
            UserDefaultsManager.isMobile = 0
            request.mobileCode = nil
        case .Email:
            loginCase = .Mobile
            UserDefaultsManager.isMobile = 1
            request.mobileCode = UserDefaultsManager.config?.data?.countriesPhoneList?.first
        }
        setCase()
    }
    
    @IBAction func didBeginTyping(_ sender: Any) {
        fieldView.borderColor = UIColor("#2C2826")
    }
    
    @IBAction func didEndTyping(_ sender: Any) {
        fieldView.borderColor = UIColor("#C8C8C8")
        verifyButton.backgroundColor = UIColor("#ECECEC")
        verifyButton.setTitleColor(UIColor("#2C2826"), for: .normal)
    }
    
    @IBAction func didChangeTyping(_ sender: UITextField) {
        fieldView.borderColor = UIColor("#C8C8C8")
        if loginCase == .Email {
            if !sender.text.emptyIfNull.isValidEmail {
                setupError()
            } else {
                setupValid()
            }
        }
    }
    
    @IBAction func didTapVerify(_ sender: UIButton) {
        if loginCase == .Mobile {
            request.mobile = mobileTF.text.emptyIfNull
        } else {
            request.email = mobileTF.text.emptyIfNull
        }
        
        if !request.isValid && loginCase == .Mobile {
            errorLB.text = "Please Enter Mobile Number".localized
            errorLB.isHidden = false
            errorImage.isHidden = false
            return
        }
        
        if !request.isValid && loginCase == .Email {
            errorLB.text = "Please Enter Email".localized
            errorLB.isHidden = false
            errorImage.isHidden = false
            return
        }
        
        if isSignup && nameTextField.text!.isEmpty {
            nameErrorLabel.text = "Please Enter Name".localized
            nameErrorLabel.isHidden = false
            nameErrorImage.isHidden = false
            return
        }
        
        if isSignup {
            request.name = nameTextField.text
        }
        
        sender.showSpinner(spinnerColor: .black)
        viewModel.loginRegiserUser(request: request) {result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    @IBAction func didTapGoToTerms(_ sender: Any) {
        router.goToTerms()
    }
    
    @IBAction func didTapGoToPolicy(_ sender: Any) {
        router.goToPolicy()
    }
    
    @IBAction func didTapSignUp(_ sender: UIButton) {
        if !isSignup {
            router.goToSignUp()
        }
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        if isSignup {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension LoginVC {
    
    func setCase(){
        switch loginCase {
        case .Mobile:
            smsLB.text = "an SMS to your number".localized
            switchButton.setTitle("Or Email".localized, for: .normal)
            mobilePrefixView.isHidden = false
            fileldImageView.image = UIImage(named: "ic_phone")
            errorLB.text = "Please enter valid mobile number".localized
            mobileTF.keyboardType = .asciiCapableNumberPad
            mobileTF.placeholder = "5xxxxxxxx"
        case .Email:
            smsLB.text = "a message to your email".localized
            switchButton.setTitle("Or Mobile".localized, for: .normal)
            mobilePrefixView.isHidden = true
            fileldImageView.image = UIImage(named: "ic_email")
            errorLB.text = "Please enter valid email address".localized
            mobileTF.keyboardType = .emailAddress
            mobileTF.placeholder = "Enter your email address".localized
        }
    }
    
    func setupError(){
        fieldView.borderColor = UIColor("#EE343A")
        errorLB.isHidden = false
        errorImage.isHidden = false
        verifyButton.backgroundColor = UIColor("#ECECEC")
        verifyButton.setTitleColor(UIColor("#2C2826"), for: .normal)
    }
    
    func setupValid(){
        fieldView.borderColor = UIColor("#C8C8C8")
        errorLB.isHidden = true
        errorImage.isHidden = true
        verifyButton.backgroundColor = UIColor("#2C2826")
        verifyButton.setTitleColor(.white, for: .normal)
    }
    
    func onSuccess(_ response: AuthModel.Response){
        removeSpinner()
        if let user = response.customer {
            UserDefaults.standard.setValue(user.mobile, forKey: "mobile")
            UserDefaults.standard.setValue(user.email, forKey: "email")
//            UserDefaults.standard.setValue(user.activationCode, forKey: "activationCode")
//            let text = "You Must Activate Your Account".localized + "\n" + user.activationCode.zeroIfNull.description
//            MainHelper.shared.showNoticeWithButton(message:  text, buttonTitle: "Close".localized) {
//            }
            router.isFromIntro = isFromIntro
            router.goToActivate()
        }
    }
}

enum LoginCases{
    case Mobile
    case Email
}
