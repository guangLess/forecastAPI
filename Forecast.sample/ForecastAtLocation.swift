//
//  Location.swift
//  Forecast.sample
//
//  Created by Guang on 6/15/16.
//  Copyright © 2016 Guang. All rights reserved.
//

import Foundation

struct ForecastAtItsLocation {
    var timezone: String
    var apparentTemperature: NSNumber
    var summary: String
    var weekForecasts = [Daily]()
}

struct Daily {
    var time: NSNumber
    var temperatureMin: NSNumber
    var temperatureMax: NSNumber
}
