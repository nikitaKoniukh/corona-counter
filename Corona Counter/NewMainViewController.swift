//
//  NewMainViewController.swift
//  Corona Counter
//
//  Created by Nikita Koniukh on 05/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

import UIKit
import PieCharts
import RxCocoa
import RxSwift
import CoreLocation

class NewMainViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDelegate {

    //Outlets
    @IBOutlet var totalCasesLbl: UILabel!
    @IBOutlet var activeCasesCardView: UIView!
    @IBOutlet var minorIndicatorView: UIView!
    @IBOutlet var seriousIndicatorView: UIView!
    @IBOutlet var activeCasesLbl: UILabel!
    @IBOutlet var recoveredCasesLbl: UILabel!
    @IBOutlet var deathLbl: UILabel!
    @IBOutlet var recoveredCardView: UIView!
    @IBOutlet var deathCardView: UIView!
    @IBOutlet var currentCountryCardView: UIView!
    @IBOutlet var currentCountryNameLbl: UILabel!
    @IBOutlet var currentCountryFlafImage: UIImageView!
    @IBOutlet var pieChart: PieChart!
    @IBOutlet var majorPercentageLbl: UILabel!
    @IBOutlet var minorPercentageLbl: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    //MARK: - Properties
    let disposeBag = DisposeBag()
    let coronaApi = CoronaCounterAPI()
    var countrydDataSourse = PublishSubject<[Country]>()
    let refreshControll = UIRefreshControl()
    var locationManager: CLLocationManager?
    //var countriesArray = [Country]()
    var currentCountryString: String?
    var currentCountry: Country?

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        setupTapGestureForCurrentCountry()
        setupView()
        showTable()
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)

        coronaApi.fetchAllCountriesTotal { (result) in
            self.fetchGlobalData(result: result)
        }

        coronaApi.fetchAllCountries { (result) in
            let sortedByActiveCases = result.sorted {
                $0.active > $1.active
            }
            self.countrydDataSourse.onNext(sortedByActiveCases)
        }
    }

    func setupTapGestureForCurrentCountry() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapForCurrentCountry))
        currentCountryCardView.addGestureRecognizer(tap)
    }

    @objc func handleTapForCurrentCountry() {
        if let country = currentCountry {
            performSegue(withIdentifier: SEGUE_TO_NEW_DETAILS, sender: country)
        }
    }

    private func showTable() {
        countrydDataSourse.bind(to: collectionView.rx.items(cellIdentifier: COLLECTION_VIEW_CELL_ID))
        {(row,country:Country,cell: CountryCollectionViewCell) in
            DispatchQueue.main.async {
                cell.configureCell(country: country)
                if let imageURL = URL(string: country.flag){
                    cell.flagImageView.image = UIImage()
                    cell.flagImageView.af.setImage(withURL: imageURL)
                }
            }
        }.disposed(by: disposeBag)
    }

    private func fetchCurrentCountry(currentCountry: Country) {
        currentCountryNameLbl.text = currentCountry.country
        self.currentCountry = currentCountry
        if let imageURL = URL(string: currentCountry.flag){
            currentCountryFlafImage.af.setImage(withURL: imageURL)
        }
    }

    private func fetchGlobalData(result: Country) {
        totalCasesLbl.text = result.cases.commaRepresentation
        activeCasesLbl.text = result.active.commaRepresentation
        recoveredCasesLbl.text = result.recovered.commaRepresentation
        deathLbl.text = result.deaths.commaRepresentation

        let criticalPercentage =  getPercentageForMinorAndSeriousCases(critical: result.critical, activeCases: result.active)
        let activeCasesPercentage = 100 - criticalPercentage
        minorPercentageLbl.text = "\(activeCasesPercentage)%"
        majorPercentageLbl.text = "\(criticalPercentage)%"
        pieChart.models = [
            PieSliceModel(value: Double(criticalPercentage), color: #colorLiteral(red: 0.9904027581, green: 0.3548480272, blue: 0.3655920029, alpha: 1)),
            PieSliceModel(value: Double(activeCasesPercentage), color: #colorLiteral(red: 0.3577479124, green: 0.8051960468, blue: 0.9972313046, alpha: 1)),
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
        recoveredCardView.setupCardView(cRadius: 8.0, sColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), sOffset: CGSize(width: 4, height: 4), sRadius: 4.0, sOpacity: 0.5)
        deathCardView.setupCardView(cRadius: 8.0, sColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), sOffset: CGSize(width: 4, height: 4), sRadius: 4.0, sOpacity: 0.5)
        currentCountryCardView.setupCardView(cRadius: 8.0, sColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), sOffset: CGSize(width: 4, height: 4), sRadius: 4.0, sOpacity: 0.5)
    }

    //MARK: - CLLocationManager
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            checkLocationAuthorization()
        } else {
            print("No service")
        }
    }

    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            getLocationCoordinates()
        case .denied:
            //show alert how to turn on permissions
            break
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            //            currentCountryContainer.isHidden = true
            //            heightConstraintForContainerCountry.constant = 0
            //            tableView.isHidden = false
        } else if (status == CLAuthorizationStatus.authorizedWhenInUse) {
            getLocationCoordinates()
            //tableView.isHidden = false
        }
    }

    private func getLocationCoordinates() {
        if let location = locationManager?.location?.coordinate {
            convertLatLongToAddress(latitude: location.latitude, longitude: location.longitude)
        }
    }

    private func convertLatLongToAddress(latitude:Double,longitude:Double){
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in

            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]

            if let country = placeMark.country {
                self.coronaApi.fetchCurrentCountry(currentCountryName: country) { (result) in
                    print(result.country)
                    self.fetchCurrentCountry(currentCountry: result)
                }
            }
        })
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == SEGUE_TO_NEW_DETAILS) {
            guard let detailVC = segue.destination as? NewDetailViewController else { return }
            let destination = sender as! Country
            detailVC.currentCountry = destination
        }
    }
}
