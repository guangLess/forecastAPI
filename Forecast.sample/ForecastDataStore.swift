//
//  DataStore.swift
//  Forecast.sample
//
//  Created by Guang on 6/14/16.
//  Copyright © 2016 Guang. All rights reserved.
//

import Foundation
import Alamofire

class ForecastDataStore {
    
    static let sharedInstance = ForecastDataStore()
    private let apiKey = ForecastApiKey()
    
    func getCurrentLocation () -> Bool {
        return true 
    }
    
    func getForecastFromAPI() {
        
        let params = [ "latitude": 40.783435,
                       "longitude": -73.966249]
        let requestUrl = String(format: "https://api.forecast.io/forecast/%@",apiKey.forecastKey, params)
        
      Alamofire.request(.GET, requestUrl)
        .validate()
        .responseJSON { response in
            switch response.result{
            case.Success:
                let responseValue = response.result.value
                print(responseValue)
                
            case .Failure(let error) :
                print(error)
            }
        }
   
    }
}
