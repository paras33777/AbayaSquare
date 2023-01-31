//
//  Float.swift
//  Hemaya
//
//  Created by Mohamed Zakout on 7/8/20.
//  Copyright © 2020 Mohamed Zakout. All rights reserved.
//

import Foundation

//extension Double {
//    var clean: String {
//       return String(format: "%.2f", self)
//    }
//}

extension Double {
    var clean: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        return formatter.string(from: self as NSNumber) ?? ""
    }
    
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }

}
