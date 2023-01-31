//
//  UILabel.swift
//  Sharwa
//
//  Created by Mohamed Zakout on 9/30/20.
//

import UIKit

extension UILabel {
    @IBInspectable
    var spaceBetweenLines: CGFloat {
        get {
            return 0.0
        }
        set {
            let attributedString = NSMutableAttributedString(string: text ?? "")
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = newValue
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            attributedText = attributedString
        }
    }
    
    var maxNumberOfLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font as Any], context: nil).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}

extension UILabel {
    @IBInspectable
    var baseLineOffset: CGFloat {
        get {
            return 0.0
        }
        set {
            let attributes: [NSAttributedString.Key:Any] = [.baselineOffset : newValue]
            attributedText = NSAttributedString(string: text ?? "", attributes: attributes)
        }
    }
            
    @IBInspectable
    var lineHeight: CGFloat {
        get {
            return 0.0
        }
        set {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = newValue
            paragraphStyle.alignment = textAlignment
            
            let baseLineOffset = 2
            let attributes: [NSAttributedString.Key:Any] = [.paragraphStyle : paragraphStyle,
                                                            .baselineOffset : -abs(baseLineOffset)]
            
            if let attributedText = attributedText {
                let newAttributed = NSMutableAttributedString(attributedString: attributedText)
                newAttributed.addAttributes(attributes, range: NSRange(location: 0, length: attributedText.string.count))
                self.attributedText = newAttributed
            } else if let text = text {
                attributedText = NSAttributedString(string: text, attributes: attributes)
            }
        }
    }
}
