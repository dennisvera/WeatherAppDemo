//
//  Weather.swift
//  WeatherAppDemo
//
//  Created by Dennis Vera on 11/11/17.
//  Copyright © 2017 Dennis Vera. All rights reserved.
//

import Foundation

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
    let description: String
    let icon: String
}
