//
//  APIHandler.swift
//  EWSN
//
//  Created by Noh Tewolde on 4/10/19.
//  Copyright © 2019 Noh Tewolde. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireObjectMapper

let baseurl = "https://api.darksky.net/forecast/5c4ff1491baaa0a640cdb4b88279ca0f/%@,%@"


class APIHandler: NSObject {
    
    override private init() {}
    
    static var sharedInstance = APIHandler()
    
    func fetchData(_ lat : Double, _ long : Double, completion : @escaping (_ result : WeatherData?) -> Void ) {
        let requestURL = String(format: baseurl, String(lat), String(long))
        Alamofire.request(requestURL).responseObject { (response : DataResponse<WeatherData>) in
            let dsResponse = response.result.value
            completion(dsResponse)
            print(dsResponse)
        }
    }
}
