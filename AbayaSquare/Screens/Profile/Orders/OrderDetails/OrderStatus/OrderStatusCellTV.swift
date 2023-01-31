//
//  OrderStatusTV.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/25/21.
//

import UIKit
import IBAnimatable

class OrderStatusCellTV: UITableViewCell {

    @IBOutlet weak var statusLB: UILabel!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var dashLineView: AnimatableView!
    @IBOutlet weak var detailsLB: UILabel!
    @IBOutlet weak var dateLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkView.backgroundColor = UIColor("#569542")
        dashLineView.borderColor = UIColor("#569542")
    }
    
    func config(with model: StatusLog) {
        statusLB.text = model.status?.name
        detailsLB.text = model.status?.details
        dateLB.text = model.createdAt
    }
}
