//
//  OrderCell.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/25/21.
//

import UIKit

protocol OrderCellDelegate {
    func didReturnProduct(_ cell: OrderCell)
}

class OrderCell: UITableViewCell {
    
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var orderIdLB: UILabel!
    @IBOutlet weak var deliveryTimeLB: UILabel!
    @IBOutlet weak var productNameLB: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var returnView: UIView!
    @IBOutlet weak var returnLB: UILabel!
    
    @IBOutlet weak var desginerNameLB: UILabel!
    var delegate: OrderCellDelegate?
    
    static let identifier = "OrderCell"
    
    override func awakeFromNib() {
        
        returnLB.text = "Return".localized
    }
    
    func config(with model: Order){
        orderImage.image = UIImage(named: "logo_auth")
        orderIdLB.text = model.name
        deliveryTimeLB.text = ""
        if model.productsCount == 1 {
            productNameLB.text = model.firstProductName
        } else {
            productNameLB.text = "Products Count: ".localized + model.productsCount.zeroIfNull.description
        }
    }
    
    func config(with model: OrderProduct){
        arrowImage.isHidden = true
        desginerNameLB.isHidden = false
        desginerNameLB.text = model.store?.name
        orderImage.setImage(url: model.product?.mainImage)
        orderIdLB.text = model.product?.name
        deliveryTimeLB.text = "Quantity:".localized + " " + model.qty.zeroIfNull.description
        productNameLB.text = "Price:".localized + " " + model.price.zeroIfNull.clean
    }
    
    
    @IBAction func didTapReturn(_ sender: Any) {
        delegate?.didReturnProduct(self)
    }
}
