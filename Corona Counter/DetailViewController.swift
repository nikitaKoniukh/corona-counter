//
//  DetailViewController.swift
//  Corona Counter
//
//  Created by Nikita Koniukh on 27/04/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class DetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var firstView: UIView!
    @IBOutlet var secondView: UIView!

    @IBOutlet var countryNameLabel: UILabel!
    @IBOutlet var confirmedCasesLabel: UILabel!
    @IBOutlet var testsLabel: UILabel!
    @IBOutlet var todayCases: UILabel!
    @IBOutlet var activeCasesLabel: UILabel!
    @IBOutlet var criticalLabel: UILabel!
    @IBOutlet var deathLabel: UILabel!
    @IBOutlet var recoveredLabel: UILabel!
    @IBOutlet var continentLabel: UILabel!
    @IBOutlet var flagImage: UIImageView!

    let coronaCounterApi = CoronaCounterAPI()
    var country: Country!

    override func viewDidLoad() {
        super.viewDidLoad()
        firstView.isHidden = true
        secondView.isHidden = true

        firstView.setupCardForDetailView()
        secondView.setupCardForDetailView()

        publishResult(countruResult: country)
        getFlagImage(imgUrl: country.flag)
    }

    private func publishResult(countruResult: Country) {
        countryNameLabel.text = countruResult.country
        confirmedCasesLabel.text = String(countruResult.cases)
        testsLabel.text = String(countruResult.tests)
        todayCases.text = String(countruResult.todayCases)
        activeCasesLabel.text = String(countruResult.active)
        criticalLabel.text = String(countruResult.critical)
        deathLabel.text = String(countruResult.deaths)
        recoveredLabel.text = String(countruResult.recovered)
        continentLabel.text = countruResult.continent
    }

    private func getFlagImage(imgUrl: String) {
        let downloader = ImageDownloader()
        guard let url = URL(string: imgUrl) else { return }
        let urlRequest = URLRequest(url: url)

        downloader.download(urlRequest) { response in
            if case .success(let image) = response.result {
                self.flagImage.image = image
                self.firstView.isHidden = false
                self.secondView.isHidden = false
            }
        }
    }
}
