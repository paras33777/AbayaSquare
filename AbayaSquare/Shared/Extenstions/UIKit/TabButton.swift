//
//  TabButton.swift
//  HouseKitchenChef
//
//  Created by Ayman  on 3/30/21.
//

import Foundation
import IBAnimatable

class TapButton: AnimatableButton {
    
    override func awakeFromNib() {
        cornerRadius = 6
        borderColor = UIColor("#7C7160")
        borderWidth = 1
        deselect()
    }
    
    func select(){
        backgroundColor = UIColor("#7C7160")
        setTitleColor(.white, for: .normal)
    }
    
    func deselect(){
        backgroundColor = .white
        titleLabel?.font  = .boldSystemFont(ofSize: 12)
        setTitleColor(UIColor("#7C7160"), for: .normal)
    }
}

class TabbySelectButton: AnimatableButton {

    override func awakeFromNib() {
        cornerRadius = 6
        deselect()
    }
    
    func select(){
        backgroundColor = UIColor("#7C7160")
        titleLabel?.font  = .boldSystemFont(ofSize: 15)
        setTitleColor(.white, for: .normal)
        borderWidth = 0
    }
    
    func deselect(){
        backgroundColor = .white
        borderColor = UIColor("#7C7160")
        titleLabel?.font  = .systemFont(ofSize: 15)
        borderWidth = 1
        setTitleColor(UIColor("#2C2826"), for: [])
    }
}




class RightAlignedIconButton: AnimatableButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let availableSpace = bounds.inset(by: contentEdgeInsets)
        let availableWidth = availableSpace.width - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        
        if L102Language.isRTL {
            semanticContentAttribute = .forceLeftToRight
            contentHorizontalAlignment = .left
            titleEdgeInsets = UIEdgeInsets(top: 4, left: availableWidth, bottom: 0, right: 0)
            
        } else {
            semanticContentAttribute = .forceRightToLeft
            contentHorizontalAlignment = .right
            titleEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: availableWidth)
        }
    }
    
    func setup() {
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layoutSubviews()
    }
}

class SelectButton: AnimatableButton {
    override func awakeFromNib() {
        cornerRadius = 20
    }
    
    func select(){
        titleLabel?.font  = .boldSystemFont(ofSize: 17)
        setTitleColor(UIColor("#FF9500"), for: .normal)
    }
    
    func deselect(){
        titleLabel?.font  = .systemFont(ofSize: 17)
        setTitleColor(UIColor.white.withAlphaComponent(0.33), for: .normal)
    }
}


extension UIButton {
    func underline(font: UIFont) {
        guard let text = self.titleLabel?.text else { return }
        self.titleLabel?.font = font
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
