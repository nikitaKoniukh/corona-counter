//
//  Number+Commas.swift
//  Corona Counter
//
//  Created by Nikita Koniukh on 06/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

import Foundation

extension Int {
     private static var commaFormatter: NumberFormatter = {
           let formatter = NumberFormatter()
           formatter.numberStyle = .decimal
           return formatter
       }()

       internal var commaRepresentation: String {
           return Int.commaFormatter.string(from: NSNumber(value: self)) ?? ""
       }
}
