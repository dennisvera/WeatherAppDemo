//
//  OpenWetaherAPIClient.swift
//  WeatherAppDemo
//
//  Created by Dennis Vera on 11/11/17.
//  Copyright © 2017 Dennis Vera. All rights reserved.
//

import UIKit

class OpenWeatherAPIClient {
    
    let weatherAPIKey = "eed0c9c1fc5ed97518d97298e9f009eb"
    
    func getTodaysWeather(city: String, completionHandler: @escaping (WeatherModel) -> ()) {
        
        let jsonUrlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&units=imperial&APPID=\(weatherAPIKey)"
        
        guard let url = URL(string: jsonUrlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else {return}
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                let description = weather.list[0].weather[0].description
                let tempAvg = weather.list[0].main.temp
                let tempMax = weather.list[0].main.temp_max
                let tempMin = weather.list[0].main.temp_min
                
                let weatherModel = WeatherModel(description: description, tempAverage: tempAvg, tempMinimum: tempMin, tempMaximum: tempMax)
                print(weatherModel)
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            }.resume()
    }
    
    
}
