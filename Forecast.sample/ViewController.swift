//
//  ViewController.swift
//  Forecast.sample
//
//  Created by Guang on 6/14/16.
//  Copyright © 2016 Guang. All rights reserved.
//

import UIKit
import Alamofire

//TODO: follow prolific style guid
class ViewController: UIViewController {

    let locationManagerInstance: CurrentLocation = CurrentLocation.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManagerInstance.prepareToGetLocation()
        
        if let location = locationManagerInstance.locationManager.location {
            print(location.coordinate)
        } else {
            //locationManagerInstance.prepareToGetLocation()
        }
        
        getForecastFromAPI()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getForecastFromAPI() {
        let apiKey = ForecastApiKey()

        let params = "40.7834,-73.966"
        let requestUrl = String(format: "https://api.forecast.io/forecast/%@/%@",apiKey.forecastKey, params)
        
        //let requestUrl = "https://api.forecast.io/forecast/95e1ec396c42ac8713e4c8f56f3dde42/37.8267,-122.423"
        //print(requestUrl)
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
                                if let eachDay = days["data"] {
                                    print(eachDay!.lastObject!!["summary"])
                                }
                            }
                        }
                    }
                    //if let responseValue = response.result.value as! [String : AnyObject] {
                   // print(responseValue)
                        //for forcast in responseValue as! [[String:AnyObject]] {
                          
                            //var simplfiedWeekForecast = [Daily]()
                            
                            /*
                            for eachDay in forcast["daily"] as! [[String : AnyObject]]  {
                                let dailyForecast = Daily(time: eachDay["time"] as! String, temperatureMin: eachDay["temperatureMin"] as! String, temperatureMax: eachDay["temperatureMax"] as! String)
                                    simplfiedWeekForecast.append(dailyForecast)
                                }
                            //TOFIX: this eachDay method needs to move to another method because the program wont run through this.
                            */
                        
                           //let forecast = responseValue
                    
//                            let currentForecast = ForecastAtItsLocation(timezone: forecast["timezone"] as! String, apparentTemperature: forecast["apparentTemperature"] as! String, summary: forecast["summary"] as! String, weekForecasts: [] )
//                            print (currentForecast)
                       // }

                       // }
                    //}
                case .Failure(let error) :
                    print(error)
                }
        }
        
    }
}

