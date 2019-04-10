//
//  WeatherData.swift
//  EWSN
//
//  Created by Noh Tewolde on 4/10/19.
//  Copyright © 2019 Noh Tewolde. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class WeatherData: NSObject, Mappable {
    var currentTemp : Int?
    var dailyHigh: Double?
    var dailyLow: Double?
    var summary: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        currentTemp <- map["currently.temperature"]
        dailyHigh <- map["daily.data.0.temperatureHigh"]
        dailyLow <- map["daily.data.0.temperatureLow"]
        summary <- map["currently.summary"]
    }
}
