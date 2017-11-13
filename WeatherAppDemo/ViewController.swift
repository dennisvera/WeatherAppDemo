//
//  ViewController.swift
//  WeatherAppDemo
//
//  Created by Dennis Vera on 11/11/17.
//  Copyright © 2017 Dennis Vera. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var averageTempLabel: UILabel!
    
    let weatherAPI = OpenWeatherAPIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWeather(with: "Miami")
    }
    
    func getWeather(with city: String) {
        weatherAPI.getWeatherForecast(with: city) { (forecast) in
            
            var averageTemperature = forecast.forecast[0]["main"]["temp"].doubleValue
            var description = forecast.forecast[0]["weather"][0]["description"].stringValue
            
            averageTemperature = Double(round(10*averageTemperature)/10)
            description = description.capitalized
            
            DispatchQueue.main.async {
                self.descriptionLabel.text = description
                self.averageTempLabel.text = "\(averageTemperature)°"
            }
        }
    }
    
    
    
}






