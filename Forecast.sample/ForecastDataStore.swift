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
    
    
    func getForecastFromAPI(completion: ( currentForecast:ForecastAtItsLocation ) -> Void) {
        //let apiKey = ForecastApiKey()
        
        let params = "40.7834,-73.966"
        let requestUrl = String(format: "https://api.forecast.io/forecast/%@/%@",apiKey.forecastKey, params)
        
        //let requestUrl = "https://api.forecast.io/forecast/95e1ec396c42ac8713e4c8f56f3dde42/37.8267,-122.423"
        //print(requestUrl)
        var weekForecast = [Daily]()
        
        Alamofire.request(.GET, requestUrl)
            .validate()
            .responseJSON { response in
                switch response.result{
                case.Success:
                    if let successResult = response.result.value {
                        print(successResult["currently"])
                        if let daily = successResult["daily"]  {
                            if let days = daily {
                                print(days["data"])
                                if let currentWeek = days["data"] {
                                    print(currentWeek!.lastObject!!["summary"])
                                    
                                    let lastDay = (currentWeek?.lastObject)! as! [String : AnyObject] //as AnyObject
                                    print (lastDay["summary"])
                                    //let tempForecast = Daily(time: lastDay["time"] as! NSNumber, temperatureMin: lastDay["temperatureMin"] as! String, temperatureMax: lastDay["temperatureMax"] as! String)
                                    //weekForecast.append(tempForecast)
                                    //TOFIX: use generics or refactor thoes optional unwrapings.
                                    if let week = currentWeek {
                                        for day in week as! [[String : AnyObject]] {
                                            let dayInWeekForecast = Daily(time: day["time"] as! NSNumber, temperatureMin: day["temperatureMin"] as! NSNumber, temperatureMax: day["temperatureMax"] as! NSNumber)
                                            weekForecast.append(dayInWeekForecast)
                                            print(weekForecast.count)
                                            if weekForecast.count == 8 {
                                                let currently = successResult["currently"] as! [String : AnyObject]
                                                let currentForecast = ForecastAtItsLocation(timezone: successResult["timezone"] as! String, apparentTemperature: currently["apparentTemperature"] as! NSNumber, summary: currently["summary"] as! String, weekForecasts: weekForecast)
                                                
                                                completion(currentForecast: currentForecast)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                case .Failure(let error):
                    print(error)
                }
        }
    }
}
