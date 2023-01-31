//
//  String.swift
//  BaseProject
//
//  Created by Ashwaq on 12/31/19.
//  Copyright © 2019 Selsela. All rights reserved.
//

import UIKit

extension Int {
    var double: Double {
        return Double(self)
    }
    
    var int64: Int64 {
        return Int64(self)
    }
    
    var int16: Int16 {
        return Int16(self)
    }
}
 
extension Int {
    var toSting: String {
        return self.description
    }
}

extension Int {
  var asWord: String? {
    let numberValue = NSNumber(value: self)
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    return formatter.string(from: numberValue)
  }
}

extension Int {
    var ordinal: String {
        var suffix: String
        if self == 1 {
            suffix = "First".localized
        } else if self == 2 {
            suffix = "Second".localized
        } else if self == 3 {
            suffix = "Thrid".localized
        } else if self == 4 {
            suffix = "Fourth".localized
        } else if self == 5{
            suffix = "Fivth".localized
        } else if self == 6{
            suffix = "Sixth".localized
        } else if self == 7{
            suffix = "Seventh".localized
        } else if self == 8{
            suffix = "Eighth".localized
        } else if self == 9{
            suffix = "Ninth".localized
        } else {
            suffix = ""
        }
        return suffix
    }
}
