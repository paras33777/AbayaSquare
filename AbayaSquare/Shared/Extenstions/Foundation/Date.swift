//
//  Date.swift
//  HomeFood
//
//  Created by Mohamed Zakout on 18/12/2020.
//

import Foundation

extension Date {
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    var currentTimeMinusOneHour: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/MM/yyyy, hh"
        let modifiedDate =  Calendar.current.date(byAdding: .hour, value: -1, to: self)!
        return formatter.string(from: modifiedDate)
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: self)
    }
    
    var readableTimeString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: self)
    }
}

extension Optional where Wrapped == Date {
    var readableTimeString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.dateFormat = "hh:mm a"
        guard let self = self else { return "" }
        return formatter.string(from: self)
    }
}

extension String {
    var date: Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "hh:mm a"
        return formatter.date(from: self)
    }
    
    func date(formate: String = "dd/MM/yyyy, hh:mm a") -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = formate
        return formatter.date(from: self)
    }
}
