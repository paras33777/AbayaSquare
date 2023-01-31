//
//  CategoriesCellVertical.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/3/21.
//

import UIKit

class CategoriesCellVertical: UICollectionViewCell {

    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryNameLB: UILabel!
    
    static let identifier = "CategoriesCellVertical"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(with model: Category){
        
        categoryImage.setImage(url: model.imageUrl)
        categoryNameLB.text = model.name
    }
}
