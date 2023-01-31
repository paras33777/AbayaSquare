//
//  AddressCell.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/25/21.
//

import UIKit
import SwipeCellKit

protocol AddressCellDelegate {
    func didDeleteAddress(_ cell: AddressCell)
}

class AddressCell: UITableViewCell {

    @IBOutlet weak var addressTypeLB: UILabel!
    @IBOutlet weak var usernameLB: UILabel!
    @IBOutlet weak var addressDetailsLB: UILabel!
    
    var delegate: AddressCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(with model: Address){
        let mobile = model.mobile.emptyIfNull
        usernameLB.text = "\(model.name ?? "") | \(mobile)"
        addressTypeLB.text = model.type
        addressDetailsLB.text = model.address
    }
    
    @IBAction func didTapDeleteAddress(_ sender: Any) {
        delegate?.didDeleteAddress(self)
    }
}
