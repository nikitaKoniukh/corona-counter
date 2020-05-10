//
//  Number+Commas.swift
//  Corona Counter
//
//  Created by Nikita Koniukh on 06/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//


import Foundation

enum DateFormat {
    case iso8601, rfc822, incompleteRFC822
    case custom(String)
}

extension Date {
    // MARK: Date From String
    init(fromString string: String, format: DateFormat)
    {
        if string.isEmpty {
            self.init()
            return
        }
        
        switch format {
            case .iso8601:
                
                var s = string
                if string.hasSuffix(" 00:00") {
                    s = s.substring(to: s.index(s.endIndex, offsetBy: -6)) + "GMT"
                } else if string.hasSuffix("+00:00") {
                    s = s.substring(to: s.index(s.endIndex, offsetBy: -6)) + "GMT"
                } else if string.hasSuffix("Z") {
                    s = s.substring(to: s.index(s.endIndex, offsetBy: -1)) + "GMT"
                } else if string.hasSuffix("+0000") {
                    s = s.substring(to: s.index(s.endIndex, offsetBy: -5)) + "GMT"
                }

                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
                if let date = formatter.date(from: string as String) {
                    self.init(timeInterval:0, since:date)
                } else {
                    self.init()
                }
                
            case .rfc822:
                
                var s  = string
                if string.hasSuffix("Z") {
                    s = s.substring(to: s.index(s.endIndex, offsetBy: -1)) + "GMT"
                } else if string.hasSuffix("+0000") {
                    s = s.substring(to: s.index(s.endIndex, offsetBy: -5)) + "GMT"
                } else if string.hasSuffix("+00:00") {
                    s = s.substring(to: s.index(s.endIndex, offsetBy: -6)) + "GMT"
                }
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss ZZZ"
                if let date = formatter.date(from: string as String) {
                    self.init(timeInterval:0, since:date)
                } else {
                    self.init()
                }
            
            case .incompleteRFC822:
                
                var s  = string
                if string.hasSuffix("Z") {
                    s = s.substring(to: s.index(s.endIndex, offsetBy: -1)) + "GMT"
                } else if string.hasSuffix("+0000") {
                    s = s.substring(to: s.index(s.endIndex, offsetBy: -5)) + "GMT"
                } else if string.hasSuffix("+00:00") {
                    s = s.substring(to: s.index(s.endIndex, offsetBy: -6)) + "GMT"
                }
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "d MMM yyyy HH:mm:ss ZZZ"
                if let date = formatter.date(from: string as String) {
                    self.init(timeInterval:0, since:date)
                } else {
                    self.init()
                }
            
            case .custom(let dateFormat):
                
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = dateFormat
                if let date = formatter.date(from: string as String) {
                    self.init(timeInterval:0, since:date)
                } else {
                    self.init()
                }
        }
    }
     

    

    // MARK: To String
    
    func toString() -> String {
        return self.toString(dateStyle: .short, timeStyle: .short, doesRelativeDateFormatting: false)
    }
    
    func toString(format: DateFormat) -> String
    {
        var dateFormat: String
        switch format {
            case .iso8601:
                dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            case .rfc822:
                dateFormat = "EEE, d MMM yyyy HH:mm:ss ZZZ"
            case .incompleteRFC822:
                dateFormat = "d MMM yyyy HH:mm:ss ZZZ"
            case .custom(let string):
                dateFormat = string
        }
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }

    func toString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, doesRelativeDateFormatting: Bool = false) -> String
    {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.doesRelativeDateFormatting = doesRelativeDateFormatting
        return formatter.string(from: self)
    }
   
}
