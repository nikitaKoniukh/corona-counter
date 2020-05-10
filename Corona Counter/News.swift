//
//  News.swift
//  Corona Counter
//
//  Created by Nikita Koniukh on 09/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

import Foundation

struct News {
    let title: String
    let description: String
    let pubdate: Date
    let link: String

     private enum CodingKeys: String, CodingKey {
           case title
           case newsDescription = "description"
           case pubdate
           case link
       }
}
