//
//  FilterTypesCellTV.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/25/21.
//

import UIKit

class FilterTypesCellTV: UITableViewCell {

    @IBOutlet weak var typeLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            contentView.backgroundColor = .white
        } else {
            contentView.backgroundColor = UIColor("#F4EFE7")
        }
    }

}
