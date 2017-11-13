//
//  OpenWetaherAPIClient.swift
//  WeatherAppDemo
//
//  Created by Dennis Vera on 11/11/17.
//  Copyright © 2017 Dennis Vera. All rights reserved.
//

import UIKit
import SwiftyJSON

class OpenWeatherAPIClient {
    
    let weatherAPIKey = "eed0c9c1fc5ed97518d97298e9f009eb"
    
    func getWeatherForecast(with city: String, completionHandler: @escaping (Forecast) -> ()) {
        
        let jsonUrlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&units=imperial&APPID=\(weatherAPIKey)"
        
        let session = URLSession.shared
        guard let url = URL(string: jsonUrlString) else {return}
        
        let dataTask = session.dataTask(with: url, completionHandler: { data, response, err -> Void in
            if let jsonData = data {
                let json = JSON(data: jsonData)
                let list = json["list"]
                
                let weather = Forecast(forecast: list)
                completionHandler(weather)
                
            } else {
                print("no data received: \(String(describing: err))")
            }
        })
        
        dataTask.resume()
    }
}












