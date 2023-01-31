//
//  ProfileVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var usernameLB: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var profileTV: UITableView!
    @IBOutlet weak var otherTV: UITableView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var shareIcon: UIImageView!
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var snapchatView: UIView!
    @IBOutlet weak var whatsappView: UIView!
    @IBOutlet weak var instagramView: UIView!
    @IBOutlet weak var twitterView: UIView!

    private let router = ProfileRouter()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        if !User.isLoggedIn {
            userImage.image = UIImage(named: "placeholder")
            userImage.contentMode = .scaleAspectFill
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile".localized
        router.viewController = self
        profileTV.register(nibName: ProfileCell.identifier)
        otherTV.register(nibName: ProfileCell.identifier)
        ProfileModel.setup()
        OtherModel.setup()
        OtherModel1.setup1()
        otherTV.tableFooterView = UIView().with(height: 20)
        setupGesture()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupDetails), name: .UserDidLogged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupDetails), name: .UserDidLogout, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupDetails), name: .UserDidUpdateProfile, object: nil)
        setupDetails()
        setupSocialLinks()
    }
    
    func setupSocialLinks() {
        guard let settings = UserDefaultsManager.config?.data?.settings else {return}
        facebookView.isHidden = (settings.facebook == nil)
        snapchatView.isHidden = (settings.snapchat == nil)
        instagramView.isHidden = (settings.instagram == nil)
        whatsappView.isHidden = (settings.whatsapp == nil)
        twitterView.isHidden = (settings.twitter == nil)
    }
    
    @IBAction func didTapCall(_ sender: Any) {
        if UserDefaultsManager.config?.data?.settings?.mobile == "" {
            MainHelper.shared.showNoticeMessage(message: "No Mobile Number".localized)
        } else {
            MainHelper.shared.makeCall(UserDefaultsManager.config?.data?.settings?.mobile ?? "")
        }
    }
    
    @IBAction func didTapMessage(_ sender: Any) {
        if UserDefaultsManager.config?.data?.settings?.whatsapp == "" {
            MainHelper.shared.showNoticeMessage(message: "No WhatsApp".localized)
        } else {
            let whatsApp = UserDefaultsManager.config?.data?.settings?.whatsapp ?? ""
            if whatsApp.containsOnlyDigits {
                MainHelper.shared.openWhatsapp(whatsApp)
            } else {
                MainHelper.shared.showErrorMessage(responseMessage: "No WhatsApp".localized)
            }
        }
    }
    
    @IBAction func didTapEmail(_ sender: Any) {
        if UserDefaultsManager.config?.data?.settings?.email == "" {
            MainHelper.shared.showNoticeMessage(message: "No Email".localized)
        } else {
            MainHelper.shared.openEmail(mail: UserDefaultsManager.config?.data?.settings?.email ?? "")
        }
    }
    
    @IBAction func didTapGoToLogin(_ sender: Any) {
        if User.isLoggedIn {
            var activityItems: [Any] = []
            guard let code = User.currentUser?.promoCode else { return }
            let webSiteLink = "https://abayasquare.com/home"
            let text = "Download AbaySquare App and use this promo code".localized + " " + code + " " + "and enjoy shopping your abayas".localized + "\n" + webSiteLink
            activityItems.append(text)
            let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            present(activityVC, animated: true, completion: nil)
        } else {
            router.goToLogin()
        }
    }
    
    @IBAction func openFaceBook(_ sender: UIButton) {
        guard let facebook =  UserDefaultsManager.config?.data?.settings?.facebook else { return }
        MainHelper.shared.open(facebook)
    }
    
    @IBAction func openInsta(_ sender: Any) {
        guard let instagram =  UserDefaultsManager.config?.data?.settings?.instagram else { return }
        MainHelper.shared.openInstagram(instagram)
    }
    
    @IBAction func openWhatsApp(_ sender: UIButton) {
        guard let whatsApp =  UserDefaultsManager.config?.data?.settings?.whatsapp else { return }
        if whatsApp.containsOnlyDigits {
            MainHelper.shared.openWhatsapp(whatsApp)
        } else {
            MainHelper.shared.open(whatsApp)
        }
    }
    
    @IBAction func openTwitter(_ sender: UIButton) {
        guard let twitter =  UserDefaultsManager.config?.data?.settings?.twitter else { return }
        MainHelper.shared.open(twitter)
    }
    
    @IBAction func openSnapchat(_ sender: UIButton) {
        guard let snapchat =  UserDefaultsManager.config?.data?.settings?.snapchat else { return }
        MainHelper.shared.openSnapchat(snapchat)
    }
}

extension ProfileVC {
    func setupGesture() {
        userImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToProfile))
        userImage.addGestureRecognizer(tap)
    }
    
    @objc func setupDetails(){
        if !User.isLoggedIn {
            profileView.isHidden = true
            usernameLB.text = "Hello Guest!".localized
            loginButton.setTitle("Login/Register".localized, for: .normal)
            shareIcon.isHidden = true
        } else {
            shareIcon.isHidden = false
            profileView.isHidden = false
        }
        otherTV.reloadData()
        guard let user = User.currentUser else { return }
        if user.name == nil {
            if user.mobile == nil {
                usernameLB.text = user.email
            } else {
                usernameLB.text = user.mobile
            }
        } else {
            usernameLB.text = user.name
        }
        userImage.setImage(url: user.avatarUrl)
        userImage.contentMode = .scaleAspectFill
        let code = user.promoCode ?? ""
        let text = "Reward Code:".localized + " " + code
        loginButton.setTitle(text, for: .normal)
    }
    
    @objc func goToProfile(){
        if User.isLoggedIn {
            router.goToUserProfile()
        } else {
            router.goToLogin()
        }
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == profileTV {
            return ProfileModel.items.count
        } else if tableView == otherTV{
            if UserDefaultsManager.token == nil{
             
                return OtherModel1.items1.count
            }else{
                return OtherModel.items.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
        if tableView == otherTV {
            
            if UserDefaultsManager.token == nil{
                cell.cellImage.isHidden = true
                cell.cellLB.font = .systemFont(ofSize: 16)
                let type = OtherModel1.items1[indexPath.row]
                if type == .Logout {
                    if User.isLoggedIn {
                        cell.cellLB.text = "Logout".localized
                    } else {
                        cell.cellLB.text = "Login".localized
                    }
                } else {
                    if type == .Language {
                        if L102Language.isRTL {
                            cell.cellLB.text = "Engilsh"
                        } else {
                            cell.cellLB.text = "العربية"
                        }
                    } else {
                        cell.cellLB.text = OtherModel1.items1[indexPath.row].title
                    }
                }
            }else{
            cell.cellImage.isHidden = true
            cell.cellLB.font = .systemFont(ofSize: 16)
            let type = OtherModel.items[indexPath.row]
            if type == .Logout {
                if User.isLoggedIn {
                    cell.cellLB.text = "Logout".localized
                } else {
                    cell.cellLB.text = "Login".localized
                }
            } else {
                if type == .Language {
                    if L102Language.isRTL {
                        cell.cellLB.text = "Engilsh"
                    } else {
                        cell.cellLB.text = "العربية"
                    }
                } else {
                    cell.cellLB.text = OtherModel.items[indexPath.row].title
                }
            }
            }
        } else {
            cell.cellImage.image = ProfileModel.items[indexPath.row].image
            cell.cellLB.text = ProfileModel.items[indexPath.row].title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == profileTV {
            let profileType = ProfileModel.items[indexPath.row]
            switch profileType {
            case .MyOrders:
                router.goToMyOrders()
            case .Wallet:
                router.goToWallet()
            case .ManageAddress:
                router.goToMyAddresses()
            case .DiscountCodes:
                router.goToDiscountCodes()
            case .MyFavourite:
                router.goToFavourite()
            case .Notifications:
                router.goToNotifications()
            }
        } else {
            
            if UserDefaultsManager.token == nil{
                let otherType = OtherModel1.items1[indexPath.row]
                switch otherType {
                case .Language:
                    if L102Language.isRTL {
                        MainHelper.shared.changeLanguageToEnglish()
                    } else {
                        MainHelper.shared.changeLanguageToArabic()
                    }
                case .AboutUs:
                    router.type = .About
                    router.goToAbout()
                case .PrivacyPolicy:
                    router.type = .PrivacyPolicy
                    router.goToAbout()
                case .TersmAndConditions:
                    router.type = .TermsAndConditions
                    router.goToAbout()
                case .Logout:
                    if User.isLoggedIn {
                        router.logout()
                    } else {
                        router.goToLogin()
                    }
                }
              
            }else{
            let otherType = OtherModel.items[indexPath.row]
            switch otherType {
            case .Language:
                if L102Language.isRTL {
                    MainHelper.shared.changeLanguageToEnglish()
                } else {
                    MainHelper.shared.changeLanguageToArabic()
                }
            case .AboutUs:
                router.type = .About
                router.goToAbout()
            case .PrivacyPolicy:
                router.type = .PrivacyPolicy
                router.goToAbout()
            case .TersmAndConditions:
                router.type = .TermsAndConditions
                router.goToAbout()
            case .Logout:
                if User.isLoggedIn {
                    router.logout()
                } else {
                    router.goToLogin()
                }
            case .DeleteAccount:
                router.deleteAccount()
            }
          }
        }
    }
    
    
}
