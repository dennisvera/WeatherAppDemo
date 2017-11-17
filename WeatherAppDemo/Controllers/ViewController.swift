//
//  ViewController.swift
//  WeatherAppDemo
//
//  Created by Dennis Vera on 11/11/17.
//  Copyright © 2017 Dennis Vera. All rights reserved.
//

import UIKit
import SwiftyJSON
import GooglePlaces
import GoogleMaps
import CoreLocation

class ViewController: UIViewController, UICollectionViewDataSource, CLLocationManagerDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UISearchControllerDelegate {
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var averageTempLabel: UILabel!
    @IBOutlet var maximumTempLabel: UILabel!
    @IBOutlet var minimumTempLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var weatherIconImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    
    let weatherAPI = OpenWeatherAPIClient()
    var weatherJSON: JSON?
    var weatherTemp: Int?
    
    let myCity = "Brooklyn"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWeatherForecast(with: myCity)
        searchField()
    }
    
    // MARK: - Retrieve OpenWeather data and update UI
    
    func getWeatherForecast(with city: String) {
        weatherAPI.getWeatherForecast(with: city) { (forecast) in
            
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
    
    // MARK: Create Dates
    
    func getDates(value: Int) -> String {
        let today = NSDate()
        let tomorrow = NSCalendar.current.date(byAdding: .day, value: value, to: today as Date, wrappingComponents: false)
        
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.month, .day, .year], from: tomorrow! as Date)
        
        let month = components.month
        let day = components.day
        let year =  components.year
        let dateArranged = "\(month ?? 0)-\(day ?? 0)-\(year ?? 0)"
        return dateArranged
    }
    
    func getDayOfWeek(_ today: String) -> String? {
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
    
    // MARK: - SearchController / SearchBar setup
    
    func searchField() {
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        searchController?.delegate = self
        searchController?.searchBar.delegate = self
        searchController?.searchBar.placeholder = "Brooklyn, NY"
        searchController?.searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.showsCancelButton = false
        self.navigationItem.titleView = searchController?.searchBar
        
        self.definesPresentationContext = true
        
        searchController?.hidesNavigationBarDuringPresentation = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController?.searchBar.placeholder = "Enter city..."
    }
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if weatherTemp != nil {
            return 7
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        if weatherTemp != nil {
            if let json = weatherJSON {
                let averageTemperature = json[indexPath.row]["main"]["temp"].intValue
                let weatherIconImageView = json[indexPath.row]["weather"][0]["icon"].stringValue
                
                cell.cellDateLabel.text = getDayOfWeek(getDates(value: indexPath.row))
                cell.cellWeatherIconImageView.image = UIImage(named: "\(weatherIconImageView)-r")
                cell.cellTempLabel.text = "\(averageTemperature)°"
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.bounds.width
        let screenHeight = collectionView.bounds.height
        let size = CGSize.init(width: (screenWidth/7)-2, height: screenHeight)
        
        return size
    }
}

// MARK: - Handle the user's selection with GooglePlaces

extension ViewController: GMSAutocompleteResultsViewControllerDelegate {
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress ?? "")
        
        self.searchController?.searchBar.text = place.name
        getWeatherForecast(with: place.name)
        collectionView.reloadData()
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}


