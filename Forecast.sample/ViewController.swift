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

    let locationManagerInstance = CurrentLocation.sharedInstance
    let currentForecastInstance = ForecastDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManagerInstance.prepareToGetLocation()
        
        if let location = locationManagerInstance.locationManager.location {
            print(location.coordinate)
        } else {
            //locationManagerInstance.prepareToGetLocation()
        }
        
        currentForecastInstance.getForecastFromAPI { (currentForecast) in
            print("end result --------> \(currentForecast.summary)")
            self.updateUI(currentForecast)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var apparentFLabel: UILabel!
    @IBOutlet weak var summeryLabel: UILabel!
    
    func updateUI (forecastInfo : ForecastAtItsLocation) {
        timeZoneLabel.text = forecastInfo.timezone
        apparentFLabel.text = String( forecastInfo.apparentTemperature )
        summeryLabel.text = forecastInfo.summary
    }
    
    
}