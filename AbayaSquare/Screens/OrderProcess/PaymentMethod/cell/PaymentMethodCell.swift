//
//  PaymentMethodCell.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/26/21.
//

import UIKit
import IBAnimatable

class PaymentMethodCell: UICollectionViewCell {
    
    
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var mainView: AnimatableView!
    @IBOutlet weak var paymentImage: UIImageView!
    @IBOutlet weak var paymentLB: UILabel!
    
    func config(with model: PaymentType){
        paymentImage.setImage(url: model.iconUrl)
        paymentLB.text = model.name
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                checkView.isHidden = false
                mainView.borderColor = UIColor("#7C7160")
            } else {
                checkView.isHidden = true
                mainView.borderColor = UIColor("#DEDEDE")
            }
        }
    }
}
