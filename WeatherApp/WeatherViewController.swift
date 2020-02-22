//
//  ViewController.swift
//  WeatherApp
//
//  Created by Henrik Frank on 2020-02-03.
//  Copyright © 2020 Henrik Frank. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var celsiusLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    let cities: [String] = getCityListFromJSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CityHandler.setCityToDisplay(cityName: "Gothenburg")
        
        for i in 0..<cities.count {
            
            if cities[i] != "" {
                CityHandler.searchResults.append(SearchResult(name: cities[i], isFavourite: false))
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let cityName = CityHandler.getCityToDisplay()
        
        let weatherAPI: WeatherAPI = WeatherAPI()
        
        weatherAPI.getWeatherData(suffix: "weather?q=\(cityName)&units=metric") { (result) in
            
            switch result {
            case .failure(let error):
                print("Error: \(error)")
            case .success(let weatherData):
                
                DispatchQueue.main.async {
                    
                    let tempInt: Int = Int(round(weatherData.main.temp))
                    
                    self.cityLabel.text = "\(weatherData.name) \(tempInt)°C"
                    
                    self.setWeatherImage(iconId: weatherData.weather[0].icon)
                }
            }
        }
    }
    
    func setWeatherImage(iconId: String) {
        
        switch(iconId) {
        case "01d":
            weatherImage.image = UIImage(systemName: "sun.max")
        case "01n":
            weatherImage.image = UIImage(systemName: "moon")
        case "02d":
            weatherImage.image = UIImage(systemName: "cloud.sun")
        case "02n":
            weatherImage.image = UIImage(systemName: "cloud.moon")
        case "03d":
            weatherImage.image = UIImage(systemName: "cloud")
        case "03n":
            weatherImage.image = UIImage(systemName: "cloud")
        case "04d":
            weatherImage.image = UIImage(systemName: "cloud.fog")
        case "04n":
            weatherImage.image = UIImage(systemName: "cloud.fog")
        case "09d":
            weatherImage.image = UIImage(systemName: "cloud.rain")
        case "09n":
            weatherImage.image = UIImage(systemName: "cloud.rain")
        case "10d":
            weatherImage.image = UIImage(systemName: "cloud.sun.rain")
        case "10n":
            weatherImage.image = UIImage(systemName: "cloud.moon.rain")
        case "11d":
            weatherImage.image = UIImage(systemName: "cloud.bolt")
        case "11n":
            weatherImage.image = UIImage(systemName: "cloud.bolt")
        case "13d":
            weatherImage.image = UIImage(systemName: "snow")
        case "13n":
            weatherImage.image = UIImage(systemName: "snow")
        case "50d":
            weatherImage.image = UIImage(systemName: "line.horizontal.3")
        case "50n":
            weatherImage.image = UIImage(systemName: "line.horizontal.3")
        default:
            weatherImage.image = UIImage(systemName: "questionmark.square")
        }
    }
}

class CityHandler {
    
    static var searchResults: [SearchResult] = []
    
    static var cityToDisplay: String?
    
    static func getCityToDisplay() -> String {
        
        return cityToDisplay ?? "Gothenburg"
    }
    
    static func setCityToDisplay(cityName: String) {
        
        self.cityToDisplay = cityName
    }
}

