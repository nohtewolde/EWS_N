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

    @IBOutlet weak var userProfilePhoto: UIButton!
    @IBOutlet weak var weeklyView: UICollectionView!
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
    var latitude = Double()
    var longitude = Double()
    var here : String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blueBackground")!)
        setupLocation()
        callWeatherApi()
    }
    
    func callWeatherApi()  {
        
        APIHandler.sharedInstance.fetchData(latitude,longitude) { (result) in
            let weatherObj : WeatherData  = result!
            self.weeklyReport = weatherObj.daily
            let low = "L: " + String(format: "%.2f", weatherObj.daily[0].lowTemp)
            let high = "H:" + String(format: "%.2f", weatherObj.daily[0].highTemp)
            let today = self.formatDate(time: weatherObj.currentTime!, format: "YYYY-MM-dd")
            let now = self.formatDate(time: weatherObj.currentTime!, format: "hh:mm")
            let here = String(weatherObj.timezone!)
            let icon = String(weatherObj.currentIcon!)
            
            DispatchQueue.main.async {
                self.mainHighLowTemp.text = high + "F  /" + low + "F"
                self.mainDate.text = today
                self.mainLocation.text = here
                self.mainTime.text = now
                self.mainImg.image = UIImage(named: icon)
                self.summary.text = weatherObj.currentSummary
                for dailyReport in weatherObj.daily {
                    self.weeklyReport.append(dailyReport)
                }
                self.weeklyView.reloadData()
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

    @IBAction func userProfilePhoto(_ sender: UIButton) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose Source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        
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
        return weeklyReport.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Item", for: indexPath) as? Report
    
        DispatchQueue.main.async {
            cell?.high.text = "\(self.weeklyReport[indexPath.item].highTemp)"
            cell?.low.text = "\(self.weeklyReport[indexPath.item].lowTemp)"
            cell?.location.text = self.weeklyReport[indexPath.item].location
            cell?.date.text = self.formatDate(time: self.weeklyReport[indexPath.item].time, format: "YYYY-MM-dd")
            let icon = self.weeklyReport[indexPath.item].icon
            cell?.icon.image = UIImage(named: icon)
            self.weeklyView.reloadData()
        }
        return cell!
    }
    
    
}

extension HomePage: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        userProfilePhoto.setImage(image, for: .normal)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
