//
//  CategoriesCellGrid.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/3/21.
//

import UIKit
import IBAnimatable

class CategoriesCellGrid: UICollectionViewCell {

    @IBOutlet weak var categoryImage: AnimatableImageView!
    @IBOutlet weak var categoryNameLB: UILabel!
    
    static let identifier = "CategoriesCellGrid"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(with model: Category){
        categoryImage.setImage(url: model.imageUrl)
        categoryNameLB.text = model.name
    }
    
    func setBorder() {
        categoryImage.corner = 8
        categoryImage.borderWidth = 1
        categoryImage.borderColor = #colorLiteral(red: 0.5843137255, green: 0.5333333333, blue: 0.462745098, alpha: 1)
        categoryNameLB.textColor = .black
    }
    
}
