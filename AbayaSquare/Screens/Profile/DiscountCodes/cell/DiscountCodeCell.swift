//
//  DiscountCodeCell.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/25/21.
//

import UIKit


var showCoupon = [Int]()
protocol DiscountCodeCellDelegate {
    func couponApplied(cell: DiscountCodeCell)
}

class DiscountCodeCell: UITableViewCell {
    
    var delegate: DiscountCodeCellDelegate?
    
    @IBOutlet weak var couponCodeLB: UILabel!
    @IBOutlet weak var discountLB: UILabel!
    @IBOutlet weak var descriptionLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(with model: Offer){
        couponCodeLB.text = model.code
        discountLB.text = model.designer?.name
        descriptionLB.text = "use the code".localized + " " + model.code.emptyIfNull + " " + "to avail this offer".localized
        showCoupon.append(model.show ?? 0)
    }
    
    @IBAction func didTapApply(_ sender: Any) {
        if !UserDefaultsManager.isDiscountCodeApplied {
            delegate?.couponApplied(cell: self)
        } else {
            MainHelper.shared.showErrorMessage(responseMessage: "Sorry you cant apply a Promo Code whenever you applied a Discount Coupon".localized)
        }
    }
}
