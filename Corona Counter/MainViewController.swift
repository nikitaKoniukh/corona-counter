//
//  MainViewController.swift
//  Corona Counter
//
//  Created by Nikita Koniukh on 30/04/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import CoreLocation

class MainViewController: UIViewController, UITableViewDelegate, CLLocationManagerDelegate {

    //MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var locationCountryLabel: UILabel!
    @IBOutlet var flagImage: UIImageView!
    @IBOutlet var confirmedCasesLabel: UILabel!
    @IBOutlet var testsLabel: UILabel!
    @IBOutlet var infectedTodayLabel: UILabel!
    @IBOutlet var activeCasesLabel: UILabel!

    @IBOutlet var clickForMorInfoButton: UIButton!
    @IBOutlet var heightConstraintForContainerCountry: NSLayoutConstraint!
    @IBOutlet var currentCountryContainer: UIView!
    @IBOutlet var cardView: UIView!
    
    //MARK: - Properties
    let disposeBag = DisposeBag()
    let coronaCounterAPI = CoronaCounterAPI()
    var countrydDataSourse = PublishSubject<[Country]>()
    let refreshControll = UIRefreshControl()
    var locationManager: CLLocationManager?
    var countriesArray = [Country]()
    var currentCountryString: String?
    var currentCountry: Country?


    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        setupView()
        fetchData()
        showTable()
        diSelectCell()
        refreshTableView()

        NotificationCenter.default.addObserver(self, selector: #selector(self.getCountriesAndCurrentCountryNotification(notification:)), name: Notification.Name(GET_COUNTRIES_NOTIF), object: nil)
    }

    private func refreshTableView() {
        tableView.refreshControl = refreshControll
        refreshControll.tintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        refreshControll.attributedTitle = NSAttributedString(string: "Refreshing data", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1), NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 16.0)!])
        refreshControll.addTarget(self, action: #selector(fetchData), for: .valueChanged)
    }

    private func showTable() {
        countrydDataSourse.bind(to: tableView.rx.items(cellIdentifier: MAIN_TABLE_VIEW_CELL_ID))
        {(row,country:Country,cell: CountryTableViewCell) in
            DispatchQueue.main.async {
                cell.configureCell(country: country)
                if let imageURL = URL(string: country.flag){
                    cell.flagImage.image = UIImage()
                    cell.flagImage.af.setImage(withURL: imageURL)
                }
            }
        }.disposed(by: disposeBag)
    }

    private func diSelectCell() {
        tableView.rx.modelSelected(Country.self).subscribe(onNext: { item in
            self.performSegue(withIdentifier: SEGUE_TO_DETAIL, sender: item)
        }).disposed(by: disposeBag)
    }

    private func setupView() {
        tableView.isHidden = true
        currentCountryContainer.isHidden = true
        setupCardView(cardView: cardView)

        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    private func setupCardView(cardView: UIView) {
        cardView.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
        cardView.layer.cornerRadius = 10.0
        cardView.layer.shadowColor = #colorLiteral(red: 0.06274509804, green: 0.06666666667, blue: 0.07450980392, alpha: 1).cgColor
        cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cardView.layer.shadowRadius = 12.0
        cardView.layer.shadowOpacity = 0.7
    }

    @objc func fetchData() {
        coronaCounterAPI.fetchAllCountries { (result) in
            self.countriesArray = result
            self.countrydDataSourse.onNext(result)
            self.refreshControll.endRefreshing()
            NotificationCenter.default.post(name: Notification.Name(GET_COUNTRIES_NOTIF), object: nil)
        }
    }

    @objc func getCountriesAndCurrentCountryNotification(notification: Notification) {
        if !countriesArray.isEmpty {
            //self.tableView.isHidden = false

            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }

        guard var country = self.currentCountryString else { return }
        if country == "United States" {
            country = "USA"
        }
        if let foundCountry = countriesArray.first(where: { $0.country == country }) {
            self.currentCountry = foundCountry
            self.setupCurrentCountry(country: foundCountry)
            self.currentCountryContainer.isHidden = false

            // save for toDay widjet
            if let userDefaults = UserDefaults(suiteName: "group.MSSmart") {
                userDefaults.set(country, forKey: "country")
            }
        } else {
            // not found
        }
    }

    private func setupCurrentCountry(country: Country) {
        locationCountryLabel.text = country.country
        confirmedCasesLabel.text = String(country.cases)
        testsLabel.text = String(country.tests)
        infectedTodayLabel.text = String(country.todayCases)
        activeCasesLabel.text = String(country.active)

        if let imageURL = URL(string: country.flag){
            flagImage.af.setImage(withURL: imageURL)
        }
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
            currentCountryContainer.isHidden = true
            heightConstraintForContainerCountry.constant = 0
            tableView.isHidden = false
        } else if (status == CLAuthorizationStatus.authorizedWhenInUse) {
            getLocationCoordinates()
            tableView.isHidden = false
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
                self.currentCountryString = country
                self.locationCountryLabel.text = country
                NotificationCenter.default.post(name: Notification.Name(GET_COUNTRIES_NOTIF), object: nil)
            }
        })
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == SEGUE_TO_DETAIL) {
            guard let detailVC = segue.destination as? DetailViewController else { return }
            let destination = sender as! Country
            detailVC.country = destination
        }
    }

    @IBAction func clickForMoreInfoButtonWasTapped(_ sender: UIButton) {
        if let country = currentCountry {
            performSegue(withIdentifier: SEGUE_TO_DETAIL, sender: country)
        }
    }
    
}
