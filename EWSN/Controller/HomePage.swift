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

class HomePage: UIViewController, CLLocationManagerDelegate  {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var greetingMsg: UILabel!
    
    @IBOutlet weak var mainHighLowTemp: UILabel!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var mainLocation: UILabel!
    @IBOutlet weak var mainTime: UILabel!
    @IBOutlet weak var mainDate: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    
    @IBOutlet weak var leftImg: UIImageView!
    @IBOutlet weak var leftLocation: UILabel!
    @IBOutlet weak var leftDate: UILabel!
    @IBOutlet weak var leftLow: UILabel!
    @IBOutlet weak var leftHigh: UILabel!
    
    
    @IBOutlet weak var centerImg: UIImageView!
    @IBOutlet weak var centerLocation: UILabel!
    @IBOutlet weak var centerDate: UILabel!
    @IBOutlet weak var centerLow: UILabel!
    @IBOutlet weak var centerHigh: UILabel!
    
    
    @IBOutlet weak var rightLocation: UILabel!
    @IBOutlet weak var rightDate: UILabel!
    @IBOutlet weak var rightLow: UILabel!
    @IBOutlet weak var rightHigh: UILabel!
    @IBOutlet weak var rightImg: UIImageView!
    
    var locationManager = CLLocationManager()
    var latitude = Double()
    var longitude = Double()
    var here : String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()
        callWeatherApi()
    }
    
    
    func callWeatherApi()  {
        
        APIHandler.sharedInstance.fetchData(latitude, longitude) { (result) in
            let weatherObj : WeatherData  = result!
            let low = "L: " + String(format: "%.2f", (weatherObj.dailyLow)!)
            let high = "H:" + String(format: "%.2f", (weatherObj.dailyHigh)!)
            let today = self.formatDate(time: (weatherObj.time)!, format: "YYYY-MM-dd")
            let now = self.formatDate(time: (weatherObj.time)!, format: "hh:mm")
            let here = String((weatherObj.timezone)!)
            DispatchQueue.main.async {
                self.mainHighLowTemp.text = high + " " + low
                self.mainDate.text = today
                self.mainLocation.text = here
                self.mainTime.text = now
                self.summary.text = weatherObj.summary
                
                self.centerHigh.text = high
                self.centerLow.text = low
                self.centerDate.text = today
                self.centerLocation.text = self.here
                
                self.leftLow.text = low
                self.leftHigh.text = high
                self.leftDate.text = today
                self.leftLocation.text = self.here
                
                self.rightLow.text = low
                self.rightHigh.text = high
                self.rightDate.text = today
                self.rightLocation.text = self.here

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
}
