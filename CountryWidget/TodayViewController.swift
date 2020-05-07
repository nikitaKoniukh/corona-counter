//
//  TodayViewController.swift
//  CountryWidget
//
//  Created by Omer Cohen on 4/30/20.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

import UIKit
import NotificationCenter
import AlamofireImage

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet var countryName: UILabel!
    @IBOutlet var recoverdLabel: UILabel!
    @IBOutlet var casesLabel: UILabel!
    @IBOutlet var activeLabel: UILabel!
    @IBOutlet var newCasesLabel: UILabel!
    @IBOutlet var flagImg: UIImageView!
    
    @IBOutlet var recoverdTitle: UILabel!
    @IBOutlet var casesTitle: UILabel!
    @IBOutlet var newCasesTitle: UILabel!
    @IBOutlet var activeTitle: UILabel!

    let coronaCounterApi = CoronaCounterAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded



    }

    func setupView() {
        countryName.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        recoverdLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        casesLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        activeLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        newCasesLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        recoverdTitle.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        casesTitle.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        newCasesTitle.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        activeTitle.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    private func addImage(imgUrl: String){
        let downloader = ImageDownloader()
        let urlRequest = URLRequest(url: URL(string: imgUrl)!)
        
        downloader.download(urlRequest) { response in
            if case .success(let image) = response.result {
                self.flagImg.image = image
            }
        }
    }

    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        DispatchQueue.global().async {
            self.coronaCounterApi.fetchCurrentCountry(currentCountryName: "Israel", completion: { (result) in
                DispatchQueue.main.async {
                self.countryName.text = result.country
                self.addImage(imgUrl: result.flag)
                self.activeLabel.text = String(result.active)
                self.casesLabel.text = String(result.cases)
                self.newCasesLabel.text = String(result.todayCases)
                self.recoverdLabel.text = String(result.recovered)
                }
                completionHandler(.newData)
            }

        )}
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
            hideElement(isHidden: true)
        } else if activeDisplayMode == .expanded {
            hideElement(isHidden: false)
            self.preferredContentSize = CGSize(width: maxSize.width, height: 160)
        }
    }
    
    private func hideElement(isHidden: Bool){
        //Values
        //activeLabel.isHidden = isHidden
        casesLabel.isHidden = isHidden
        newCasesLabel.isHidden = isHidden
        recoverdLabel.isHidden = isHidden
        
        //Titles
        recoverdTitle.isHidden = isHidden
        casesTitle.isHidden = isHidden
        //activeTitle.isHidden = isHidden
        newCasesTitle.isHidden = isHidden
    }
}
