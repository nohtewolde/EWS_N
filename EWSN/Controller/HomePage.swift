//
//  HomePage.swift
//  EWSN
//
//  Created by Noh Tewolde on 4/10/19.
//  Copyright © 2019 Noh Tewolde. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import ObjectMapper
import GooglePlaces

class HomePage: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var weeklyView: UICollectionView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var greetingMsg: UILabel!
    
    @IBOutlet weak var mainHighLowTemp: UILabel!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var mainLocation: UILabel!
    @IBOutlet weak var mainTime: UILabel!
    @IBOutlet weak var mainDate: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    
    var weeklyReport : [Daily] = [Daily]()
    var locationManager = CLLocationManager()
    var latitude = 42.3601
    var longitude = -71.0589
    var here : String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()
        callWeatherApi()
    }
    
    func callWeatherApi()  {
        
        APIHandler.sharedInstance.fetchData(latitude,longitude) { (result) in
            let weatherObj : WeatherData  = result!
            
            let low = "L: " + String(format: "%.2f", weatherObj.daily[0].lowTemp)
            let high = "H:" + String(format: "%.2f", weatherObj.daily[0].highTemp)
            let today = self.formatDate(time: weatherObj.currentTime!, format: "YYYY-MM-dd")
            let now = self.formatDate(time: weatherObj.currentTime!, format: "hh:mm")
            let here = String(weatherObj.timezone!)
            
            DispatchQueue.main.async {
                self.mainHighLowTemp.text = high + " " + low
                self.mainDate.text = today
                self.mainLocation.text = here
                self.mainTime.text = now
                self.summary.text = weatherObj.currentSummary
            }
            
            for dailyReport in weatherObj.daily {
                self.weeklyReport.append(dailyReport)
            }
            
        }
    }
    
    func formatDate(time : UInt64, format : String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let interval = TimeInterval(exactly: time)!
        let date = Date.init(timeIntervalSince1970: interval)
        return formatter.string(from: date)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last{
            latitude = loc.coordinate.latitude
            longitude = loc.coordinate.longitude
            locationManager.stopUpdatingLocation()
            callWeatherApi()
        }
    }
    
    func setupLocation(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            locationManager.startUpdatingLocation()
        }
    }

    
    @IBAction func locationSearch(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
}

extension HomePage: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        do{
                    print("Place name: \(place.name)")
                    print("Place ID: \(place.placeID)")
                    print("Place attributions: \(place.attributions)")
        }
        catch{
            print("problem handling exception")
        }

        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Failure to Handle Error")
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension HomePage:  UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? Report
        
        DispatchQueue.main.async {
            cell?.high.text = "\(self.weeklyReport[indexPath.item].highTemp)"
            cell?.low.text = "\(self.weeklyReport[indexPath.item].lowTemp)"
            cell?.location.text = self.weeklyReport[indexPath.item].location
            cell?.date.text = self.formatDate(time: self.weeklyReport[indexPath.item].time, format: "YYYY-MM-dd")
        }
        return cell!
    }
    
    
}
