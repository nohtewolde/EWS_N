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
    var latitude : String?
    var longitude : String?
    var timezone: String?
    var currentTime: UInt64?
    var currentSummary: String?
    var daily : [Daily] = [Daily]()
    
    override init() {
        
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        for i in 0...7{
            var dailyObj : Daily = Daily()
            dailyObj.highTemp <- map["daily.data.\(i).temperatureHigh"]
            dailyObj.lowTemp <- map["daily.data.\(i).temperatureLow"]
            dailyObj.summary <- map["daily.data.\(i).summary"]
            dailyObj.icon <- map["daily.data.\(i).icon"]
            dailyObj.time <- map["daily.data.\(i).time"]
            dailyObj.location <- map["timezone"]
            daily.append(dailyObj)
        }
        timezone <- map["timezone"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        currentTime <- map["currently.time"]
        currentSummary <- map["currently.summary"]
    }
}

struct Daily{
    var highTemp: Double = Double()
    var lowTemp: Double = Double()
    var summary: String = String()
    var icon: String = String()
    var time: UInt64 = UInt64()
    var location: String = String()
}
