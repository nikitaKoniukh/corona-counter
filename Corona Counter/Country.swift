//
//  Country.swift
//  Corona Counter
//
//  Created by Nikita Koniukh on 27/04/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

import Foundation

struct Country: Codable {
    let updated: Int
    let country: String
    let flag: String
    let cases: Int
    let todayCases: Int
    let deaths: Int
    let todayDeaths: Int
    let recovered: Int
    let active: Int
    let critical: Int
    let casesPerOneMillion: Int
    let deathsPerOneMillion: Int
    let tests: Int
    let testsPerOneMillion: Int
    let continent: String

}

