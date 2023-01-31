//
//  CartCell.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/26/21.
//

import UIKit

protocol CartCellDelegate {
    func decreaseProduct(_ cell: CartCell)
    func increaseProduct(_ cell: CartCell)
    func deleteProduct(_ cell: CartCell)
    func likeProduct(_ cell: CartCell)
}
var avialCode = [Int]()
var productAllListId = [Int]()

class CartCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLB: UILabel!
    @IBOutlet weak var productPriceLB: UILabel!
    @IBOutlet weak var discountLB: UILabel!
    @IBOutlet weak var offLB: UILabel!
    @IBOutlet weak var sizeLB: UILabel!
    @IBOutlet weak var storeNameLB: UILabel!
    @IBOutlet weak var quantityLB: UILabel!
    @IBOutlet weak var usedCouponLB: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var delegate: CartCellDelegate?
    
    var quantity: Int16 = 0 {
        didSet {
            quantityLB.text = "\(quantity)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(with model: ProductEntity){
        productImage.setImage(url: model.image)
        productNameLB.text = model.name
        
        print(model.cod)
        productAllListId.append(Int(model.id))
        avialCode.append(Int(model.cod))
        print(avialCode)
        
        if model.inFavorite == true {
            likeButton.setImage(UIImage(named: "ic_like_fill_small")!, for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "ic_like_small")!, for: .normal)
        }
        if model.discountRatio == 0 {
            discountLB.isHidden = true
            offLB.isHidden =  true
            productPriceLB.text = model.price.clean + " " + MainHelper.shared.currency
        } else {
            let discount = NSMutableAttributedString(string: model.price.clean + MainHelper.shared.currency).with(font: .mySystemFont(ofSize: 15)).with(textColor: UIColor("#999999")).with(strikethroughColor: "#999999")
            discountLB.attributedText = discount
        }
        
        if model.couponRatio == 0{
            productPriceLB.text = model.discountPrice.clean + " " + MainHelper.shared.currency
            if UserDefaultsManager.isPromoCodeApplied {
                offLB.text = model.promoCodeDicount.clean + " % " + "OFF".localized
            } else {
                offLB.text = model.discountRatio.clean + " % " + "OFF".localized
            }
            
        } else {
            offLB.isHidden = false
            discountLB.isHidden = false
            productPriceLB.text = model.couponPrice.clean + " " + MainHelper.shared.currency
            offLB.text = (model.couponRatio * 100).clean + " % " + "OFF".localized
            let discount = NSMutableAttributedString(string: model.price.clean + MainHelper.shared.currency).with(font: .mySystemFont(ofSize: 15)).with(textColor: UIColor("#999999")).with(strikethroughColor: "#999999")
            discountLB.attributedText = discount
            
        }
        
        sizeLB.text = "Size: ".localized + model.sizeName.emptyIfNull
        storeNameLB.text = model.designerName
        quantity = model.quantity
        quantityLB.text = model.quantity.description
        
        if model.couponCode != nil {
            usedCouponLB.isHidden = false
            usedCouponLB.text = "Used Coupon:".localized + " " + model.couponCode.emptyIfNull
        } else {
            usedCouponLB.isHidden = true
        }
    }
    
    func updateFav(_ product: ProductEntity) {
        if product.inFavorite == true {
            likeButton.setImage(UIImage(named: "ic_like_fill_small")!, for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "ic_like_small")!, for: .normal)
        }
    }
    
    @IBAction func didTapIncrease(_ sender: Any) {
        quantity += 1
        delegate?.increaseProduct(self)
    }
    
    @IBAction func didTapDecrease(_ sender: Any) {
        if quantity > 0 {
            quantity -= 1
            delegate?.decreaseProduct(self)
        }
        
        if quantity == 0 {
            NotificationCenter.default.post(name: .UserDidAddProduct, object: nil)
            delegate?.deleteProduct(self)
        }
    }
    
    @IBAction func didTapDelete(_ sender: Any) {
        delegate?.deleteProduct(self)
    }
    
    @IBAction func didLikeProduct(_ sender: Any) {
        delegate?.likeProduct(self)
    }
}
