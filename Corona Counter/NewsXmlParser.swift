//
//  XMLParser.swift
//  Corona Counter
//
//  Created by Nikita Koniukh on 09/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

import UIKit

class NewsXmlParser: NSObject, XMLParserDelegate {

    var newsArray = [News]()

    var elementName: String = String()
    var newsTitle = String()
    var newsDescription = String()
    var newsPubdate = Date()
    var newsLink = String()

    func startParsingWithContentsOfURL(completion: @escaping([News]) -> Void) {

        let url = URL(string: "https://www.who.int/rss-feeds/news-english.xml")!

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }

            let parser = XMLParser(data: data)
            parser.delegate = self
            if parser.parse() {
                completion(self.newsArray)
            }
        }
        task.resume()
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.elementName = elementName
        if elementName == "item" {
            newsTitle = String()
            newsDescription = String()
            newsPubdate = Date()
            newsLink = String()
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let news = News(title: newsTitle, description: newsDescription, pubdate: newsPubdate, link: newsLink)
            newsArray.append(news)
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            if self.elementName == "title" {
                newsTitle += data
            } else if self.elementName == "description" {
                newsDescription += data
            } else if self.elementName == "pubDate" {
                newsPubdate = convertStringToDate(stringDate: data)
            } else if self.elementName == "link" {
                newsLink += data
            }
        }
    }

    private func convertStringToDate(stringDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: stringDate)
        return date ?? Date()
    }
}
