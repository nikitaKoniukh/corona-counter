//
//  CoronaCounterAPI.swift
//  Corona Counter
//
//  Created by Nikita Koniukh on 27/04/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

import Foundation
import Alamofire

class CoronaCounterAPI {

    typealias Dictionary = [String: Any]

    func fetchAllCountries(completion: @escaping ([Country]) -> Void) {
        guard let url = URL(string: "https://corona.lmao.ninja/v2/countries?sort=0") else { return }

        var countriesArray = [Country]()

        AF.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let JSON):
                guard let resultDict = JSON as? [Dictionary]
                    else {return}

                for res in resultDict {
                    let updated = res["updated"] as! Int
                    let country = res["country"] as! String
                    let countryInfo = res["countryInfo"] as! NSDictionary
                    let flag = countryInfo["flag"] as! String
                    let cases = res["cases"] as! Int
                    let todayCases = res["todayCases"] as! Int
                    let deaths = res["deaths"] as! Int
                    let todayDeaths = res["todayDeaths"] as! Int
                    let recovered = res["recovered"] as! Int
                    let active = res["active"] as! Int
                    let critical = res["critical"] as! Int
                    let casesPerOneMillion = res["casesPerOneMillion"] as! Int
                    let deathsPerOneMillion = res["deathsPerOneMillion"] as! Int
                    let tests = res["tests"] as! Int
                    let testsPerOneMillion = res["testsPerOneMillion"] as! Int
                    let continent = res["continent"] as! String

                    countriesArray.append(Country(updated: updated,
                                                  country: country,
                                                  flag: flag,
                                                  cases: cases,
                                                  todayCases: todayCases,
                                                  deaths: deaths,
                                                  todayDeaths: todayDeaths,
                                                  recovered: recovered,
                                                  active: active,
                                                  critical: critical,
                                                  casesPerOneMillion: casesPerOneMillion,
                                                  deathsPerOneMillion: deathsPerOneMillion,
                                                  tests: tests,
                                                  testsPerOneMillion: testsPerOneMillion,
                                                  continent: continent))

                }
            case .failure(let error):
                print(error.localizedDescription)
            }

            completion(countriesArray)

        }

    }

    var country: String?
    func fetchCurrentCountry(currentCountryName: String, completion: @escaping (Country) -> Void) {
        country = currentCountryName
//        if let userDefaults = UserDefaults(suiteName: "group.MSSmart") {
//            if userDefaults.string(forKey: "country") != nil {
//                country = userDefaults.string(forKey: "country")!
//            } else {
//                country = "israel"
//            }
//        }

        if country == "United States" {
            country = "USA"
        }

        guard let url = URL(string: "https://corona.lmao.ninja/v2/countries/\(country!)") else { return }

        var newCountry: Country!

        AF.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let JSON):
                guard let resultDict = JSON as? Dictionary
                    //let countryInfoDict = resultDict as? dictionary
                    else {return}

                let updated = resultDict["updated"] as! Int
                let country = resultDict["country"] as! String
                let countryInfo = resultDict["countryInfo"] as! NSDictionary
                let flag = countryInfo["flag"] as! String

                let cases = resultDict["cases"] as! Int
                let todayCases = resultDict["todayCases"] as! Int
                let deaths = resultDict["deaths"] as! Int
                let todayDeaths = resultDict["todayDeaths"] as! Int
                let recovered = resultDict["recovered"] as! Int
                let active = resultDict["active"] as! Int
                let critical = resultDict["critical"] as! Int
                let casesPerOneMillion = resultDict["casesPerOneMillion"] as! Int
                let deathsPerOneMillion = resultDict["deathsPerOneMillion"] as! Int
                let tests = resultDict["tests"] as! Int
                let testsPerOneMillion = resultDict["testsPerOneMillion"] as! Int
                let continent = resultDict["continent"] as! String

                newCountry = Country(updated: updated,
                                     country: country,
                                     flag: flag,
                                     cases: cases,
                                     todayCases: todayCases,
                                     deaths: deaths,
                                     todayDeaths: todayDeaths,
                                     recovered: recovered,
                                     active: active,
                                     critical: critical,
                                     casesPerOneMillion: casesPerOneMillion,
                                     deathsPerOneMillion: deathsPerOneMillion,
                                     tests: tests,
                                     testsPerOneMillion: testsPerOneMillion, continent: continent)

            case .failure(let error):
                print(error.localizedDescription)
            }

            if let object = newCountry {
                completion(object)
            }

        }

    }

    func fetchAllCountriesTotal(completion: @escaping(Country) -> Void) {
        guard let url = URL(string: "https://corona.lmao.ninja/v2/all") else { return }

        var newCountry: Country!

        AF.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let JSON):
                guard let resultDict = JSON as? Dictionary
                    else {return}

                let updated = resultDict["updated"] as! Int
                let cases = resultDict["cases"] as! Int
                let todayCases = resultDict["todayCases"] as! Int
                let deaths = resultDict["deaths"] as! Int
                let todayDeaths = resultDict["todayDeaths"] as! Int
                let recovered = resultDict["recovered"] as! Int
                let active = resultDict["active"] as! Int
                let critical = resultDict["critical"] as! Int
                let casesPerOneMillion = resultDict["casesPerOneMillion"] as! Int
                let deathsPerOneMillion = resultDict["deathsPerOneMillion"] as! Int
                let tests = resultDict["tests"] as! Int
                let testsPerOneMillion = resultDict["testsPerOneMillion"] as! Double

                newCountry = Country(updated: updated,
                                     country: "",
                                     flag: "",
                                     cases: cases,
                                     todayCases: todayCases,
                                     deaths: deaths,
                                     todayDeaths: todayDeaths,
                                     recovered: recovered,
                                     active: active,
                                     critical: critical,
                                     casesPerOneMillion: casesPerOneMillion,
                                     deathsPerOneMillion: deathsPerOneMillion,
                                     tests: tests,
                                     testsPerOneMillion: Int(testsPerOneMillion), continent: "")

            case .failure(let error):
                print(error.localizedDescription)
            }

            if let object = newCountry {
                completion(object)
            }

        }

    }

}
