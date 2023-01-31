//
//  HomeCell.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/27/21.
//

import UIKit
import FSPagerView

class HomeCell: FSPagerViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLB: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    static let identifier = "HomeCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(with model: Product) {
        productImage.setImage(url: model.imageUrl)
        priceLabel.text = model.salePrice.zeroIfNull.clean + " " + MainHelper.shared.currency
        if model.isFeature == 1 {
//            let annotation = L102Language.isRTL ? model.annotationAr : model.annotationEn
//            productNameLB.text = annotation ?? model.annotation
            if model.featureImageUrl != nil {
                productImage.setImage(url: model.featureImageUrl)
            } else {
                productImage.setImage(url:model.imageUrl)
            }
        } else {
        }
        let name = L102Language.isRTL ? model.nameAr : model.nameEn
        productNameLB.text = name ?? model.name
        if model.inFavorite == true {
            favoriteButton.setImage(UIImage(named: "ic_like_fill_small")!, for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "ic_like_small")!, for: .normal)
        }
    }
    
//    @IBAction func didTapButton(_ sender: UIButton) {
//        delegate?.productAddedToFavorite(cell: self)
//    }
}
