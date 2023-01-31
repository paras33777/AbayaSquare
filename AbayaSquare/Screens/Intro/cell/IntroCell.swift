//
//  IntroCell.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import UIKit
import FSPagerView
import IBAnimatable

class IntroCell: FSPagerViewCell {

    static let identifier = "IntroCell"
    
    @IBOutlet weak var productImage: AnimatableImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
