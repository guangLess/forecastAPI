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
    var apparentTemperature: String
    var summary: String
    var weekForecasts = [Daily]()
}

struct Daily {
    var time: String
    var temperatureMin: String
    var temperatureMax: String
}
