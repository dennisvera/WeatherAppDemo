//
//  ViewController.swift
//  WeatherAppDemo
//
//  Created by Dennis Vera on 11/11/17.
//  Copyright © 2017 Dennis Vera. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var averageTempLabel: UILabel!
    @IBOutlet var maximumTempLabel: UILabel!
    @IBOutlet var minimumTempLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var weatherIconImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    
    let weatherAPI = OpenWeatherAPIClient()
    var weatherJSON: JSON!
    var weatherTemp: Int?
    
    let searchBar = UISearchBar()
    var newCitySearch = ""
    let myCity = "Brooklyn"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSearchBar()
        getWeatherForecast()
    }
    
    func getWeatherForecast() {
        weatherAPI.getWeatherForecast(with: myCity) { (forecast) in
            
            self.weatherJSON = forecast.forecast
            let averageTemperature = forecast.forecast[0]["main"]["temp"].intValue
            let maxTemperature = forecast.forecast[0]["main"]["temp_max"].intValue
            let minTemperature = forecast.forecast[0]["main"]["temp_min"].intValue
            let humidity = forecast.forecast[0]["main"]["humidity"].intValue
            let weatherIcon = forecast.forecast[0]["weather"][0]["icon"].stringValue
            var description = forecast.forecast[0]["weather"][0]["description"].stringValue
            description = description.capitalized
            
            self.weatherTemp = maxTemperature
            
            // Update UI
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.maximumTempLabel.text = "\(maxTemperature)°"
                self.minimumTempLabel.text = "\(minTemperature)°"
                self.averageTempLabel.text = "\(averageTemperature)°"
                self.humidityLabel.text = "\(humidity)%"
                self.weatherIconImageView.image = UIImage(named: weatherIcon)
                self.descriptionLabel.text = description
            }
        }
    }
    
    // MARK: Create searchBar
    
    func createSearchBar() {
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Brooklyn, NY"
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        navigationItem.titleView = searchBar
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        guard let citySearch = searchBar.text else {return}
        newCitySearch = citySearch.lowercased()
        
        weatherAPI.getWeatherForecast(with: newCitySearch, completionHandler: { (forecast) in
            let averageTemperature = forecast.forecast[0]["main"]["temp"].intValue
            let maxTemperature = forecast.forecast[0]["main"]["temp_max"].intValue
            let minTemperature = forecast.forecast[0]["main"]["temp_min"].intValue
            let humidity = forecast.forecast[0]["main"]["humidity"].intValue
            let weatherIcon = forecast.forecast[0]["weather"][0]["icon"].stringValue
            var description = forecast.forecast[0]["weather"][0]["description"].stringValue
            description = description.capitalized
            
            // Update UI
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.maximumTempLabel.text = "\(maxTemperature)°"
                self.minimumTempLabel.text = "\(minTemperature)°"
                self.averageTempLabel.text = "\(averageTemperature)°"
                self.humidityLabel.text = "\(humidity)%"
                self.weatherIconImageView.image = UIImage(named: weatherIcon)
                self.descriptionLabel.text = description
            }
        })
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.placeholder = "Search weather by city..."
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        newCitySearch = searchBar.text!
        collectionView.reloadData()
    }
    
    // MARK: Create Dates
    
    func getDates(value: Int) -> String {
        let today = NSDate()
        let tomorrow = NSCalendar.current.date(byAdding: .day, value: value, to: today as Date, wrappingComponents: false)
        
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.month, .day, .year], from: tomorrow! as Date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        let dateArranged = "\(month!)-\(day!)-\(year!)"
        return dateArranged
    }
    
    func getDayOfWeek(_ today:String) -> String? {
        let weekdays = [1:"SUN", 2:"MON", 3:"TUE", 4:"WED", 5:"THU", 6:"FRI", 7:"SAT"]
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        if let todayDate = formatter.date(from: today) {
            let myCalendar = Calendar(identifier: .gregorian)
            let weekDay = myCalendar.component(.weekday, from: todayDate)
            let day = weekdays[weekDay]
            
            return day
        } else {
            return nil
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        if weatherTemp != nil {
            let averageTemperature = weatherJSON[indexPath.row]["main"]["temp"].intValue
            let weatherIconImageView = weatherJSON[indexPath.row]["weather"][0]["icon"].stringValue
            
            cell.cellDateLabel.text = getDayOfWeek(getDates(value: indexPath.row))
            cell.cellWeatherIconImageView.image = UIImage(named: "\(weatherIconImageView)-r")
            cell.cellTempLabel.text = "\(averageTemperature)°"
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 140, height: collectionView.bounds.height)
    }
    
}


















