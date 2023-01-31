//
//  SelectAddressCell.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/26/21.
//

import UIKit
import IBAnimatable
import SwipeCellKit

class SelectAddressCell: UITableViewCell{

    @IBOutlet weak var mainView: AnimatableView!
    @IBOutlet weak var usernameLB: UILabel!
    @IBOutlet weak var addressTypeLB: UILabel!
    @IBOutlet weak var addressDetailsLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            mainView.borderColor = UIColor("#569542")
        } else {
            mainView.borderColor = UIColor("#DFDFDF")
        }
    }
    
    func config(with model: Address){
        let mobile = String(model.mobile?.suffix(9) ?? "")
        usernameLB.text = "\(model.name ?? "") | \(mobile)"
        addressTypeLB.text = model.type
        addressDetailsLB.text = model.address
    }
}
