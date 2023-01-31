//
//  SizeCellCV.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import UIKit
import IBAnimatable

class SizeCellCV: UICollectionViewCell {
    
    @IBOutlet weak var backView: AnimatableView!
    @IBOutlet weak var sizeLB: UILabel!
    
    func setupForUnAvailable() {
//        backView.borderColor = .clear
        backView.borderWidth = 0
        backView.addDashedBorder(#colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1))
        backView.backgroundColor = .clear
        sizeLB.textColor = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1)
    }
    
    func setupSelected() {

            backView.borderColor = .clear
            backView.backgroundColor = UIColor("#333333")
            sizeLB.textColor = .white
            backView.borderWidth = 1
        

    }
    
    func setupUnselected() {
        backView.borderWidth = 1
        backView.borderColor = UIColor("#666666").withAlphaComponent(0.5)
        backView.backgroundColor = .clear
        sizeLB.textColor = UIColor("#666666")
    }
}
