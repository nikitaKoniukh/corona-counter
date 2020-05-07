//
//  UIView+CardView.swift
//  Corona Counter
//
//  Created by Nikita Koniukh on 05/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

import UIKit

extension UIView {
    func setupCardView(cRadius: CGFloat, sColor: CGColor, sOffset: CGSize, sRadius: CGFloat, sOpacity: Float) {
        self.layer.cornerRadius = cRadius
        self.layer.shadowColor = sColor
        self.layer.shadowOffset = sOffset
        self.layer.shadowRadius = sRadius
        self.layer.shadowOpacity = sOpacity
    }

    func setupCardForDetailView() {
        self.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
        self.layer.cornerRadius = 20.0
        self.layer.shadowColor = #colorLiteral(red: 0.06418050466, green: 0.06844631398, blue: 0.07524610891, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 12.0
        self.layer.shadowOpacity = 0.7
    }
    func setupViewWithCornerRadius(cRadius: CGFloat) {
        self.layer.cornerRadius = cRadius
    }


}
