//
//  DesignerCell.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import UIKit

class DesignerCell: UICollectionViewCell {

    @IBOutlet weak var designerImage: UIImageView!
    @IBOutlet weak var designerNameLB: UILabel!
    
    static let identifier = "DesignerCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(with model: Designer) {
        designerImage.setImage(url: model.imageUrl)
        designerNameLB.text = model.name
    }
    
}
