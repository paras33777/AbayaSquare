//
//  NSMutableAttributedString.swift
//  Travel
//
//  Created by Mohamed Zakout on 05/03/2021.
//

import UIKit

extension Array where Element == NSMutableAttributedString {
    var joined: NSMutableAttributedString {
        let string = NSMutableAttributedString()
        forEach {
            string += $0
            if !string.string.contains("\n") {
                string += NSMutableAttributedString(string: " ")
            }
        }
        return string
    }
    
    func joined(space: Int) -> NSMutableAttributedString {
        let string = NSMutableAttributedString()
        forEach {
            string += $0
            var i = 0
            while i < space {
                string += NSMutableAttributedString(string: " ")
                i += 1
            }
        }
        return string
    }
}

extension NSTextAttachment {
    var string: NSMutableAttributedString {
        return NSMutableAttributedString(attachment: self)
    }
    
    func with(imageName: String) -> Self {
        image = UIImage(named: imageName)
        return self
    }
}

extension NSMutableAttributedString {
    class var newLine: NSMutableAttributedString {
        return NSMutableAttributedString(string: "\n")
    }
    
    class var comma: NSMutableAttributedString {
        return NSMutableAttributedString(string: ",")
    }
    
    class var space: NSMutableAttributedString {
        return NSMutableAttributedString(string: " ")
    }
    
    class var blackKitchenIcon: NSMutableAttributedString {
        let icon = NSTextAttachment()
        icon.image = UIImage(named: "ic_kitchen_type")?.withRenderingMode(.alwaysTemplate).withTintColor(.black)
        return icon.string
    }
    
    class var calendarIcon: NSMutableAttributedString {
        let icon = NSTextAttachment()
        icon.image = UIImage(named: "ic_calendar")?.withRenderingMode(.alwaysTemplate).withTintColor(.black)
        return icon.string
    }
    
    func append(attr: NSMutableAttributedString) -> NSMutableAttributedString {
        append(attr)
        return self
    }
    
    func with(font: UIFont) -> NSMutableAttributedString {
        addAttributes([.font : font], range: NSRange(location: 0, length: length))
        return self
    }
    
    func with(backgroundColor: UIColor) -> NSMutableAttributedString {
        addAttributes([.backgroundColor : backgroundColor], range: NSRange(location: 0, length: length))
        return self
    }
    
    func with(textColor: UIColor) -> NSMutableAttributedString {
        addAttributes([.foregroundColor : textColor], range: NSRange(location: 0, length: length))
        return self
    }
    
    func with(textColor: String) -> NSMutableAttributedString {
        addAttributes([.foregroundColor : UIColor(hexString: textColor)], range: NSRange(location: 0, length: length))
        return self
    }
    
    func with(strikethroughColor: String) -> NSMutableAttributedString {
        addAttributes([.strikethroughStyle : NSUnderlineStyle.single.rawValue], range: NSRange(location: 0, length: length))
        addAttributes([.strikethroughColor : UIColor(strikethroughColor)], range: NSRange(location: 0, length: length))
        return self
    }
    
    func with(paragraphStyle: NSMutableParagraphStyle) -> NSMutableAttributedString {
        addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: length))
        return self
    }
    
    func with(alignment: NSTextAlignment) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: length))
        return self
    }
    
    func setAttachmentsAlignment(_ alignment: NSTextAlignment) {
        self.enumerateAttribute(NSAttributedString.Key.attachment, in: NSRange(location: 0, length: self.length), options: .longestEffectiveRangeNotRequired) { attribute, range, stop in
            if attribute is NSTextAttachment {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = alignment
                self.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
            }
        }
    }
    
    func with(baseLine: CGFloat) -> Self {
        addAttribute(.baselineOffset, value: baseLine, range: NSRange(location: 0, length: length))
        return self
    }
    
    func setLineSpacing(_ space: CGFloat) -> NSMutableAttributedString {
        var hasCurrentStyle = false
        
        self.enumerateAttribute(NSAttributedString.Key.paragraphStyle, in: NSRange(location: 0, length: self.length), options: .longestEffectiveRangeNotRequired) { attribute, range, stop in
            if let attribute = attribute as? NSMutableParagraphStyle {
                attribute.lineSpacing = space
                hasCurrentStyle = true
            }
        }
        
        if !hasCurrentStyle {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = space
            addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: length))
        }
        
        return self
    }
    
    func with(lineHeightMultiple: CGFloat) -> NSMutableAttributedString {
        self.enumerateAttribute(NSAttributedString.Key.paragraphStyle, in: NSRange(location: 0, length: self.length), options: .longestEffectiveRangeNotRequired) { attribute, range, stop in
            if let attribute = attribute as? NSMutableParagraphStyle {
                attribute.lineHeightMultiple = lineHeightMultiple
            }
        }
        return self
    }
    
    func setTextAlignment(_ alignment: NSTextAlignment) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: length))
    }
    
    func setTextColor(_ color: UIColor) {
        addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: length))
    }
    
    static func += (left: NSMutableAttributedString, right: NSMutableAttributedString) {
        left.append(right)
    }
}
