//
//  DesignerSearchCell.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/8/21.
//

import UIKit

class DesignerSearchCell: UICollectionViewCell {

    @IBOutlet weak var designerNameLB: UILabel!
    @IBOutlet weak var designerImage: UIImageView!
    
    static let identifier = "DesignerSearchCell"
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func config(with model: Designer){
        designerNameLB.text = model.name
        designerImage.setImage(url: model.imageUrl)
    }
}
