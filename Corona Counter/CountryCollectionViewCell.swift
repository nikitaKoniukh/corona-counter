//
//  CountryCollectionViewCell.swift
//  Corona Counter
//
//  Created by Nikita Koniukh on 07/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

import UIKit
import PieCharts

class CountryCollectionViewCell: UICollectionViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var flagImageView: UIImageView!
    @IBOutlet var countryLbl: UILabel!
    @IBOutlet var pieView: PieChart!
    
    override func layoutSubviews() {
        containerView.setupCardView(cRadius: 8.0, sColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), sOffset: CGSize(width: 4, height: 4), sRadius: 4.0, sOpacity: 0.5)
    }

    func configureCell(country: Country) {

        let criticalPercentage =  getPercentageForMinorAndSeriousCases(critical: country.critical, activeCases: country.active)
        let activeCasesPercentage = 100 - criticalPercentage

        countryLbl.text = country.country

        if (criticalPercentage == 0.0) {
            pieView.models = [
                PieSliceModel(value: activeCasesPercentage, color: #colorLiteral(red: 0.3577479124, green: 0.8051960468, blue: 0.9972313046, alpha: 1))
            ]
        } else {
            pieView.models = [
                PieSliceModel(value: Double(criticalPercentage), color: #colorLiteral(red: 0.9904027581, green: 0.3548480272, blue: 0.3655920029, alpha: 1)),
                PieSliceModel(value: Double(activeCasesPercentage), color: #colorLiteral(red: 0.3577479124, green: 0.8051960468, blue: 0.9972313046, alpha: 1)),
            ]
        }
    }

    private func getPercentageForMinorAndSeriousCases(critical: Int, activeCases: Int) -> Double {
        if critical == 0  {
            return 0.0
        } else {
            let criticalPercentage = Double(critical) / Double((activeCases / 100))
            return criticalPercentage
        }
    }
}
