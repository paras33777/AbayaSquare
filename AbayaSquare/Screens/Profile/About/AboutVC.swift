//
//  AboutVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import UIKit

class AboutVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var type: AboutCases = .About
    let viewModel = AboutViewModel()
    var pageSting: [String] = [""]
    
    override func viewWillAppear(_ animated: Bool) {
        switch type {
        case .About:
            title = "About".localized
        case .PrivacyPolicy:
            title = "Privacy Policy".localized
        case .TermsAndConditions:
            title = "Terms & Conditions".localized
        }
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPageContent()
    }
}

extension AboutVC {
    func getPageContent(){
        view.showSpinner(spinnerColor: .black)
        viewModel.getAppContent(){ result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    func onSuccess(_ response: AboutModel.Response){
        switch type {
        case .About:
            pageSting[0] = response.appContents?.aboutUs?.htmlStripped ?? ""
        case .PrivacyPolicy:
            pageSting[0] = response.appContents?.privacyAndPolicy?.htmlStripped ?? ""
        case .TermsAndConditions:
            pageSting[0] = response.appContents?.termsAndConditions?.htmlStripped ?? ""
        }
        tableView.reloadData()
        removeSpinner()
    }
}

extension AboutVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageSting.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell", for: indexPath) as! AboutCell
        switch type {
        case .About:
            cell.questionTitleLB.text = "About".localized
        case .PrivacyPolicy:
            cell.questionTitleLB.text = "Privacy Policy".localized
        case .TermsAndConditions:
            cell.questionTitleLB.text = "Terms & Conditions".localized
        }
        cell.questionAnswerLB.text = pageSting[indexPath.row]
        return cell
    }
}

enum AboutCases {
    case About
    case PrivacyPolicy
    case TermsAndConditions
}
