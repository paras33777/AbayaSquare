//
//  ColorCellTV.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/25/21.
//

import UIKit

class ColorCellTV: UITableViewCell {

    
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var cellLB: UILabel!
    @IBOutlet weak var productCount: UILabel!
    
    static let identifier = "ColorCellTV"
    var cellIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(with model: Color) {
        cellLB.text = model.name
        checkView.backgroundColor = UIColor(model.colorHex ?? "")
        productCount.text = model.productsCount.zeroIfNull.description
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            checkImage.isHidden = false
            cellLB.font = .boldSystemFont(ofSize: 14)
            if cellIndex == 0 {
                checkView.backgroundColor = UIColor("#7C7160")
            }
        } else {
            checkImage.isHidden = true
            cellLB.font = .systemFont(ofSize: 14)
            if cellIndex == 0 {
                checkView.backgroundColor = .white
            }
        }
    }
    
}
