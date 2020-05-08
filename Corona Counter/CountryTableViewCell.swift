//
//  CountryTableViewCell.swift
//  Corona Counter
//
//  Created by Nikita Koniukh on 30/04/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class CountryTableViewCell: UITableViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var flagImage: UIImageView!
    @IBOutlet var countryNameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        containerView.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
        containerView.layer.cornerRadius = 10.0
        containerView.layer.shadowColor = #colorLiteral(red: 0.06418050466, green: 0.06844631398, blue: 0.07524610891, alpha: 1).cgColor
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        containerView.layer.shadowRadius = 12.0
        containerView.layer.shadowOpacity = 0.7
    }

    func configureCell(country: Country) {
        countryNameLabel.text = country.country
        numberLabel.text = String(country.active)
    }
}
