//
//  SortCell.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import UIKit

class SortCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            cellImage.isHidden = false
        } else {
            cellImage.isHidden = true
        }
    }

}
