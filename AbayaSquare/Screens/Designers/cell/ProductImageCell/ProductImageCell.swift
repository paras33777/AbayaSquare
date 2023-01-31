//
//  ProductImageCell.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/13/21.
//

import UIKit
import FSPagerView

class ProductImageCell: FSPagerViewCell {

    @IBOutlet weak var productImage: UIImageView!
    static let identifier = "ProductImageCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
