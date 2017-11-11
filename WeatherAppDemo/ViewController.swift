//
//  ViewController.swift
//  WeatherAppDemo
//
//  Created by Dennis Vera on 11/11/17.
//  Copyright © 2017 Dennis Vera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonUrlString = "https://api.openweathermap.org/data/2.5/forecast?q=Brooklyn&units=imperial&APPID=eed0c9c1fc5ed97518d97298e9f009eb"
        
        guard let url = URL(string: jsonUrlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else {return}
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                print(weather.list[0])
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            }.resume()
    }
    
    
    
}

