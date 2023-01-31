//
//  SortVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import UIKit

class SortVC: BottomSheetViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var strings: [String] = ["What's New".localized,
                             "Price Low to High".localized,
                             "Price High to Low".localized]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView().with(height: 30)
    }
}
 
extension SortVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortCell", for: indexPath) as! SortCell
        cell.cellLB.text = strings[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            NotificationCenter.default.post(name: .ShowAll, object: nil)
        case 1:
            NotificationCenter.default.post(name: .ShowLowestPrice, object: nil)
        case 2:
            NotificationCenter.default.post(name: .ShowHighestPrice, object: nil)
        default:
            print("error")
        }
        dismiss(animated: true, completion: nil)
    }
}
