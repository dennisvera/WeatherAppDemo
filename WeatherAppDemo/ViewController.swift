//
//  ViewController.swift
//  WeatherAppDemo
//
//  Created by Dennis Vera on 11/11/17.
//  Copyright © 2017 Dennis Vera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let wetaherAPI = OpenWeatherAPIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    
        wetaherAPI.getTodaysWeather(city: "Brooklyn") { (success) in
            
        }
    }
}

