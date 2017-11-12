//
//  Weather.swift
//  WeatherAppDemo
//
//  Created by Dennis Vera on 11/11/17.
//  Copyright © 2017 Dennis Vera. All rights reserved.
//

import Foundation

// MARK: - OpenWetaherAPI JSON Keys

struct Weather: Decodable {
    let list: [ListKeys]
}

struct ListKeys: Decodable {
    let dt: Int
    let main: MainKeys
    let weather: [WeatherKeys]
    let dt_txt: String
}

struct MainKeys: Decodable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

struct WeatherKeys: Decodable {
    let main: String
    let description: String
    let icon: String
}


// MARK: - WeatherModel

struct WeatherModel {
    let description: String
    let tempAverage: Double
    let tempMinimum: Double
    let tempMaximum: Double
}


