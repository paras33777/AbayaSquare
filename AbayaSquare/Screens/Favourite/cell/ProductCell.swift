//
//  ProductCell.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import UIKit

protocol ProductCellDelegate{
    func productAddedToFavorite(cell: ProductCell)
}

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLB: UILabel!
    @IBOutlet weak var discountLB: UILabel!
    @IBOutlet weak var productPriceLB: UILabel!
    @IBOutlet weak var offLB: UILabel!
    
    static let identifier = "ProductCell"
    var delegate: ProductCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(with model: Product){
        productImage.setImage(url: model.mainImage)
        if model.mainImage == nil {
            productImage.setImage(url: model.imageUrl)
        }
        productNameLB.text = model.name
        productPriceLB.text = model.salePrice.zeroIfNull.clean + " " + MainHelper.shared.currency
        
        if model.inFavorite == true {
            likeButton.setImage(UIImage(named: "ic_like_fill_small")!, for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "ic_like_small")!, for: .normal)
        }
        
        if model.discountRatio == 0 {
            discountLB.text = ""
            offLB.text =  ""
        } else {
            let discount = NSMutableAttributedString(string: model.price.zeroIfNull.clean + MainHelper.shared.currency).with(font: .systemFont(ofSize: 15)).with(textColor: UIColor("#999999")).with(strikethroughColor: "#999999")
            discountLB.attributedText = discount
            offLB.text = model.discountRatio.zeroIfNull.clean + " % " + "OFF".localized
        }
    }
    
    func updateFav(_ product: Product) {
        if product.inFavorite == true {
            likeButton.setImage(UIImage(named: "ic_like_fill_small")!, for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "ic_like_small")!, for: .normal)
        }
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        delegate?.productAddedToFavorite(cell: self)
    }
}
