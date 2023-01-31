//
//  NotificationCell.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/25/21.
//

import UIKit

protocol NotificationCellDelegate {
    func didDeleteNotification(_ cell: NotificationCell)
}

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var detailsLB: UILabel!
    @IBOutlet weak var timeLB: UILabel!
    
    var delegate: NotificationCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func config(with model: Notifcations){
        titleLB.text = model.title
        detailsLB.text = model.message
        timeLB.text = model.humanDate
    }
    
    @IBAction func didTapDelete(_ sender: Any) {
        delegate?.didDeleteNotification(self)
    }
}
