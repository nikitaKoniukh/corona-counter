//
//  NewDetailViewController.swift
//  Corona Counter
//
//  Created by Nikita Koniukh on 07/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

import UIKit
import PieCharts
import RxCocoa
import RxSwift

class NewDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var countryNameLbl: UILabel!
    @IBOutlet var activeCasesCardView: UIView!
    @IBOutlet var minorIndicatorView: UIView!
    @IBOutlet var seriousIndicatorView: UIView!
    @IBOutlet var activeCasesLbl: UILabel!
    @IBOutlet var recoveredCasesLbl: UILabel!
    @IBOutlet var deathLbl: UILabel!
    @IBOutlet var pieChart: PieChart!
    @IBOutlet var majorPercentageLbl: UILabel!
    @IBOutlet var minorPercentageLbl: UILabel!
    @IBOutlet var backButtonImageView: UIImageView!
    @IBOutlet var bottomContainerView: UIView!
    @IBOutlet var collectionView: UICollectionView!

    // MARK: - Properties
    var currentCountry: Country!
    var countriesArray = [Country]()
    private let disposeBag = DisposeBag()
    private var countrydDataSourse = PublishSubject<[Country]>()

    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        showCurrentCountry(currentCountry: currentCountry)
        setupTapGestureForBackButton()
        showCollectionView()
        didSelectCollectionViewItem()

        self.countrydDataSourse.onNext(countriesArray)
    }

    private func setupTapGestureForBackButton() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapForBackButton))
        backButtonImageView.addGestureRecognizer(tap)
    }

    @objc func handleTapForBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

    private func showCurrentCountry(currentCountry: Country) {
        countryNameLbl.text = currentCountry.country
        activeCasesLbl.text = currentCountry.active.commaRepresentation
        recoveredCasesLbl.text = currentCountry.active.commaRepresentation
        deathLbl.text = currentCountry.deaths.commaRepresentation

        let criticalPercentage =  getPercentageForMinorAndSeriousCases(critical: currentCountry.critical, activeCases: currentCountry.active)
        let activeCasesPercentage = 100 - criticalPercentage
        minorPercentageLbl.text = "\(activeCasesPercentage)%"
        majorPercentageLbl.text = "\(criticalPercentage)%"

        pieChart.clear()
        pieChart.models = [
            PieSliceModel(value: Double(criticalPercentage), color: #colorLiteral(red: 0.9904027581, green: 0.3548480272, blue: 0.3655920029, alpha: 1)),
            PieSliceModel(value: Double(activeCasesPercentage), color: #colorLiteral(red: 0.3577479124, green: 0.8051960468, blue: 0.9972313046, alpha: 1))
        ]
    }

    private func getPercentageForMinorAndSeriousCases(critical: Int, activeCases: Int) -> Int {
        let criticalPercentage = critical / (activeCases / 100)
        return criticalPercentage
    }

    private func setupView() {
        self.navigationController?.navigationBar.isHidden = true
        activeCasesCardView.setupCardView(cRadius: 8.0, sColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), sOffset: CGSize(width: 4, height: 4), sRadius: 4.0, sOpacity: 0.5)
        minorIndicatorView.setupViewWithCornerRadius(cRadius: 4.0)
        seriousIndicatorView.setupViewWithCornerRadius(cRadius: 4.0)
        bottomContainerView.roundCornersForTwoCorners()
    }

    // MARK: - CollectionView
    private func showCollectionView() {
        countrydDataSourse.bind(to: collectionView.rx.items(cellIdentifier: COLLECTION_VIEW_DETAIL_CELL_ID)) {(_,country:Country,cell: CountryCollectionViewCell) in
            DispatchQueue.main.async {
                cell.configureCell(country: country)
                if let imageURL = URL(string: country.flag) {
                    cell.flagImageView.image = UIImage()
                    cell.flagImageView.af.setImage(withURL: imageURL)
                }
            }
        }.disposed(by: disposeBag)
    }

    private func didSelectCollectionViewItem() {
        collectionView.rx.modelSelected(Country.self).subscribe(onNext: { item in
            self.showCurrentCountry(currentCountry: item)
            self.removeCurrentCountryFromArray(selectedCountry: item)
        }).disposed(by: disposeBag)
    }

    private func removeCurrentCountryFromArray(selectedCountry: Country) {

        let filteredArray = countriesArray.filter {$0.country != selectedCountry.country}
        countriesArray = filteredArray

        countriesArray.append(currentCountry)

        let sortedByActiveCases = countriesArray.sorted {
            $0.active > $1.active
        }

        currentCountry = selectedCountry
        self.countrydDataSourse.onNext(sortedByActiveCases)

    }
}
