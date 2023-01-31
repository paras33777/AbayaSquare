//
//  SelectAddressVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/25/21.
//

import UIKit

protocol SelectAddressDelegate {
    func didSelectAddress(address: Address)
}

class SelectAddressVC: BottomSheetViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var addresses: [Address] = []
    var delegate: SelectAddressDelegate?
    let viewModel = AddAddressViewModel()
    var nav: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = User.currentUser else {return}
        addresses = user.addresses ?? []
        tableView.reloadData()
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        animateOut()
    }
    
    @IBAction func didTapNewAddress(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddAddressVC") as! AddAddressVC
        animateOut()
        vc.hidesBottomBarWhenPushed = true
        nav?.pushViewController(vc, animated: true)
    }
}


extension SelectAddressVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectAddressCell", for: indexPath) as! SelectAddressCell
        let model = addresses[indexPath.row]
        cell.config(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let address = addresses[indexPath.row]
        animateOut()
        delegate?.didSelectAddress(address: address)
    }
}
