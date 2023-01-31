//
//  ProfileCell.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLB: UILabel!
    
    static let identifier = "ProfileCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
