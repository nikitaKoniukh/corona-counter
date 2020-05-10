//
//  NewsTableViewCell.swift
//  Corona Counter
//
//  Created by Nikita Koniukh on 10/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var descriptionLbl: UILabel!

    override func layoutSubviews() {
        containerView.setupCardView(cRadius: 8.0, sColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), sOffset: CGSize(width: 4, height: 4), sRadius: 4.0, sOpacity: 0.5)
    }

    func configureCell(news: News) {
        titleLbl.text = news.title
        dateLbl.text = news.pubdate.toString(dateStyle: .long, timeStyle: .short)
        descriptionLbl.text = news.description.stringByDecodingHTMLEntities()
    }

}
