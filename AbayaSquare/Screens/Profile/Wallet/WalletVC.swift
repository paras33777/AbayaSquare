//
//  WalletVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/9/21.
//

import UIKit

class WalletVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var balanceLB: UILabel!
    @IBOutlet weak var pointsLB: UILabel!
    @IBOutlet weak var getMoneyLB: UILabel!
    @IBOutlet weak var codeLB: UILabel!
    
    let viewModel = WalletViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Wallet".localized
        setupRefreshControl()
        updataUserData()
    }
    
    func setupRefreshControl() {
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.tintColor = .black
        scrollView.refreshControl?.addTarget(self, action: #selector(startAPI), for: .valueChanged)
    }
    
    func setupDetails(){
        guard let user = User.currentUser else {return}
        balanceLB.text = user.wallet.zeroIfNull.clean + " " + MainHelper.shared.currency
        pointsLB.text = user.points?.clean
        let money = UserDefaultsManager.config?.data?.settings?.referralRegisterPoints ?? ""
        getMoneyLB.text = "Friends and get".localized + " " + money + " " + "Points".localized
        codeLB.text = user.promoCode
    }
    
    func updataUserData(){
        view.showSpinner(spinnerColor: .black)
        startAPI()
    }
    
    @objc func startAPI() {
        viewModel.updateUserData {result in
            switch result {
            case .success(let response): self.onSuccessUpdateData(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    func onSuccessUpdateData(_ response: AuthModel.Response){
        scrollView.refreshControl?.endRefreshing()
        removeSpinner()
        if let user = response.customer {
            User.currentUser = user
            setupDetails()
        }
    }
    
    @IBAction func didTapShare(_ sender: Any) {
        var activityItems: [Any] = []
        guard let code = User.currentUser?.promoCode else { return }
        let webSiteLink = "https://abayasquare.com/home"
        let text = "Download AbaySquare App and use this promo code".localized + " " + code + " " + "and enjoy shopping your abayas".localized + "\n" + webSiteLink
        
        activityItems.append(text)
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func didTapConvertPoints(_ sender: UIButton) {
        let points = User.currentUser?.points ?? 0
        
        if points == 0 {
            MainHelper.shared.showErrorMessage(responseMessage: "You Don't Have points to convert".localized)
        } else {
            sender.showSpinner(spinnerColor: .white)
            viewModel.convertPointsToCash {result in
                switch result {
                case .success(let response): self.onSuccess(response)
                case .failure(let error): self.onFailure(error)
                }
            }
        }
    }
    
    func onSuccess(_ response: WalletModel.Response){
        removeSpinner()
        if response.status == false {
            MainHelper.shared.showErrorMessage(responseMessage: response.responseMessage.emptyIfNull)
            return
        }
        if let user = response.customer {
            User.currentUser = user
            setupDetails()
        }
    }
}



