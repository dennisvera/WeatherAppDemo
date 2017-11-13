//
//  Weather.swift
//  WeatherAppDemo
//
//  Created by Dennis Vera on 11/11/17.
//  Copyright © 2017 Dennis Vera. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK: - OpenWeatherAPI JSON Keys

struct Weather {
    let description: String
    let minTemperature: String
    let maxTemperature: String
    let avgTemperature: String
}

struct Forecast {
    let forecast: JSON
}


