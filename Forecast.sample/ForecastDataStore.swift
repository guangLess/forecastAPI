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
    private let apiKey = ForecastApiKey()
    static let sharedInstance = ForecastDataStore()
    let locationManagerInstance = CurrentLocation.sharedInstance
    let defaultCoordinateAsNewYork = "40.7834,-73.966"
    
    func getLocationCoordinate() -> String {
        locationManagerInstance.prepareToGetLocation()
        if let location = locationManagerInstance.locationManager.location {
            print(location.coordinate)
            let returnString = String(format: "%.4f,%.3f",location.coordinate.latitude, location.coordinate.longitude)
            return returnString
        } else {
        return defaultCoordinateAsNewYork
        }
    }
 
    func getForecastFromAPI(completion: ( currentForecast:ForecastAtItsLocation ) -> Void) {
        //let params = getLocationCoordinate()
        let requestUrl = String(format: "https://api.forecast.io/forecast/%@/%@",apiKey.forecastKey, getLocationCoordinate())
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
