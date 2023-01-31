
import UIKit
import DPOTPView
import SwiftMessages

class ActivateVC: UIViewController {
    
    @IBOutlet weak var activateIcon: UIImageView!
    @IBOutlet weak var timerLB: UILabel!
    @IBOutlet weak var mobileNumberLB: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var codeTF: DPOTPView!
    
    let viewModel = AuthViewModel()
    let router = AuthRouter()
    var isFormIntro = 0
    let mobileNumber = UserDefaults.standard.string(forKey: "mobile") ?? ""
    let emailAddress = UserDefaults.standard.string(forKey: "email") ?? ""
    var mobile = ""
    var loginCase: LoginCases?
    private var timer: Timer?
    private var seconds: Int = 180
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Acticate Mobile".localized
        router.viewController = self
        
        if mobileNumber.isEmpty {
            mobileNumberLB.text = emailAddress
            activateIcon.image = UIImage(named: "ic_activate_email")
        } else {
            let prefix = String(mobileNumber.prefix(3))
            mobile = String(mobileNumber.suffix(9))
            mobileNumberLB.text = String(prefix) + " - " + String(mobile)
            activateIcon.image = UIImage(named: "ic_activate")
        }
        
//        DispatchQueue.main.async {
//            self.codeTF.text = self.activationCode
//        }
        
        resendButton.underline(font: .boldSystemFont(ofSize: 14))
        setupTimer()
    }
    
    @IBAction func didTapChangeMobile(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapResendCode(_ sender: UIButton) {
        sender.showSpinner(spinnerColor: .black,backgroundColor: .white)
        var request = AuthModel.ResendCode()
        if mobileNumber.isEmpty {
            request.email = emailAddress
        } else {
            request.mobile = mobileNumber
        }
        viewModel.resendCode(request: request) { result in
            switch result {
            case .success(let response): self.onSuccessResend(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    @IBAction func didTapConfirm(_ sender: UIButton){
        let code = codeTF.text.emptyIfNull
        var request = AuthModel.Activate(code: code)
        
        if mobileNumber.isEmpty {
            request.email = emailAddress
        } else {
            request.mobile = mobileNumber
        }
        
        guard request.isValid else {
            MainHelper.shared.showErrorMessage(errors: request.errorRules)
            return
        }
        
        sender.showSpinner(spinnerColor: .black)
        
        viewModel.activateUser(request: request){result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
}

extension ActivateVC {
    func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        timer?.fire()
        resendButton.isEnabled = false
    }
    
    func resetSeconds() {
        seconds = 180
    }
    
    func onSuccess(_ response: AuthModel.Response) {
        SwiftMessages.hideAll()
        
        removeSpinner()
        if response.status == false {
            MainHelper.shared.showErrorMessage(responseMessage: response.responseMessage.emptyIfNull)
            return
        }
        
        if let user = response.customer {
            MainHelper.shared.showSuccessMessage(responseMessage: response.responseMessage.emptyIfNull)
            User.currentUser = user
            UserDefaultsManager.token = user.token
            NotificationCenter.default.post(name: .UserDidLogged, object: nil)
            if isFormIntro == 1 {
                
                if comingFrom == "cart"{
                    comingFrom = ""
                    router.goToCart()
                }else{
                    router.goToHome()
                }
                
            } else {
                navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    func onSuccessResend(_ response: ResendResponse){
        removeSpinner()
        
        if response.status == false {
            if let errors = response.errors {
                MainHelper.shared.showErrorMessage(errors: errors)
                return
            }
        } else {
            resetSeconds()
            setupTimer()
            MainHelper.shared.showSuccessMessage(responseMessage: response.responseMessage.emptyIfNull)
        }
    }
}

//MARK: - @objc functions:
extension ActivateVC {
    @objc func fireTimer() {
        seconds -= 1
        let minutes = seconds / 60 % 60
        let secondss = seconds % 60
        let time = String(format:"%02i:%02i",minutes, secondss)
        timerLB.text = time
        
        if seconds == 0 {
            timer?.invalidate()
            resendButton.isEnabled = true
        }
    }
}
