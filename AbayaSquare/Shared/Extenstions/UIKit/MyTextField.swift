//
//  MyTextField.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/31/21.
//

import Foundation
import UIKit
import IBAnimatable

protocol MyTextFieldDelegate {
    func textFieldDidDelete(textField: MyTextField)
}

class MyTextField: AnimatableTextField {
    var myDelegate: MyTextFieldDelegate?

    override func awakeFromNib() {
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        myDelegate?.textFieldDidDelete(textField: self)
    }
}
