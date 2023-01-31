//
//  AddressesVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import UIKit
//import SwipeCellKit

class AddressesVC: UIViewController {
    
    @IBOutlet weak var addressesTV: UITableView!
    
    private let router = AddressesRouter()
    var addresses: [Address] = []
    let viewModel = AddAddressViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        guard let user = User.currentUser else {return}
        addresses = user.addresses ?? []
        addressesTV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Manage Address".localized
        router.viewController = self
        addressesTV.tableHeaderView = UIView().with(height: 10)
        addressesTV.tableFooterView = UIView().with(height: 10)
    }
    
    @IBAction func didTapAddAddress(_ sender: Any) {
        router.goToAddAddress()
    }
}

extension AddressesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
        let model = addresses[indexPath.row]
        cell.config(with: model)
        cell.delegate = self
        return cell
    }
}

extension AddressesVC: AddressCellDelegate {
    func didDeleteAddress(_ cell: AddressCell) {
        if let row = addressesTV.indexPath(for: cell)?.row {
            let request = AddAddressModel.DeleteAddress(addressId: addresses[row].id)
            cell.showSpinner(spinnerColor: .black, backgroundColor: .clear)
            viewModel.deleteAddress(request: request) { result in
                switch result {
                case .success(let response):
                    if let user = response.customer {
                        MainHelper.shared.showSuccessMessage(responseMessage: "Address has Been Deleted".localized)
                        User.currentUser = user
                        self.addresses.remove(at: row)
                        self.addressesTV.deleteRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
                        self.addressesTV.reloadData()
                    }
                case .failure(let error): self.onFailure(error)
                }
            }
        }
    }    
}
