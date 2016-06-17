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
    
    let currentForecastInstance = ForecastDataStore.sharedInstance
    var daysOfForecast = [Daily]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        refreshOnPull()

        currentForecastInstance.getForecastFromAPI { (currentForecast) in
            print("end result --------> \(currentForecast.summary)")
            for eachDay in currentForecast.weekForecasts {
                self.daysOfForecast.append(eachDay)
            } //TODO: if the data is bigger, use GCD
            self.updateUI(currentForecast)
            self.tableView.reloadData()
        }
    }

    func updateUI (forecastInfo : ForecastAtItsLocation) {
        timeZoneLabel.text = forecastInfo.timezone
        apparentFLabel.text = String(format: "%d°f", Int(forecastInfo.apparentTemperature) )
        summeryLabel.text = forecastInfo.summary
    }
    //MARK: data/delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfForecast.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath:  indexPath)
        let dayForCell = daysOfForecast[indexPath.row]
        let min = round(Double(dayForCell.temperatureMin))
        let max = round(Double(dayForCell.temperatureMax))
        let cellText = String(format:"Low %.0f High %.0f -%@", min, max, self.converUnixTimeToDate(dayForCell.time))
        cell.textLabel?.text = cellText
        return cell
    }
    private func converUnixTimeToDate(unixTime : NSNumber ) -> String{
        let dateFormatter = NSDateFormatter()
        let date = NSDate(timeIntervalSince1970: Double(unixTime))
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        let convertedDateText = dateFormatter.stringFromDate(date)
        return convertedDateText
    }
    //MARK: refresh
    private func refreshOnPull () {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "🌤☄️☀️")
        refreshControl.tintColor = UIColor.yellowColor()
        refreshControl.addTarget(self, action: #selector(ViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    func refresh(control:UIRefreshControl){
        tableView.reloadData()
        control.endRefreshing()
    }
}