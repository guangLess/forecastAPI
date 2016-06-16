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
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var apparentFLabel: UILabel!
    @IBOutlet weak var summeryLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManagerInstance = CurrentLocation.sharedInstance
    let currentForecastInstance = ForecastDataStore.sharedInstance
    
    var daysOfForecast = [Daily]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

        
        locationManagerInstance.prepareToGetLocation()
        if let location = locationManagerInstance.locationManager.location {
            print(location.coordinate)
        } else {
            //locationManagerInstance.prepareToGetLocation()
        }
        
        currentForecastInstance.getForecastFromAPI { (currentForecast) in
            print("end result --------> \(currentForecast.summary)")
            for eachDay in currentForecast.weekForecasts {
                self.daysOfForecast.append(eachDay)
            }
            self.updateUI(currentForecast)
            self.tableView.reloadData()
        }
    }

    
    func updateUI (forecastInfo : ForecastAtItsLocation) {
        timeZoneLabel.text = forecastInfo.timezone
        apparentFLabel.text = String( forecastInfo.apparentTemperature )
        summeryLabel.text = forecastInfo.summary
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfForecast.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath:  indexPath)
        let dayForCell = daysOfForecast[indexPath.row]
        
        let cellText = String(format:"Low %@ High %@", dayForCell.temperatureMin, dayForCell.temperatureMax)
        
        cell.textLabel?.text = cellText
        
        //cell.textLabel?.text = daysOfForecast[indexPath.row].temperatureMax
        return cell
    }
}