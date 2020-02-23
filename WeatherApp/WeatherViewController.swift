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
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var recommendationBackground: UIView!
    @IBOutlet weak var recommendationTempLabel: UILabel!
    @IBOutlet weak var recommendationHeaderLabel: UILabel!
    @IBOutlet weak var recommendationFillerLabel: UILabel!
    @IBOutlet weak var recommendationWeatherLabel: UILabel!
    
    
    let cities: [String] = getCityListFromJSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CityHandler.setCityToDisplay(cityName: "Gothenburg")
        
        loadFavourites()
        
        for i in 0..<cities.count {
            
            if cities[i] != "" {
                CityHandler.searchResults.append(SearchResult(name: cities[i], isFavourite: false))
                
                for j in 0..<CityHandler.favourites.count {
                    if cities[i] == CityHandler.favourites[j].name {
                        CityHandler.searchResults[i - 1].isFavourite = true
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.recommendationBackground.alpha = 0
        self.recommendationBackground.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.recommendationTempLabel.alpha = 0
        self.recommendationHeaderLabel.alpha = 0
        self.recommendationFillerLabel.alpha = 0
        self.recommendationWeatherLabel.alpha = 0
        
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
                    
                    self.recommendClothing(temp: weatherData.main.temp, weather: weatherData.weather[0].icon)
                    
                    self.animateRecommendation()
                }
            }
        }
    }
    
    func recommendClothing(temp: Float, weather: String) {
        
        var tempClothes: String
        var weatherClothes: String
        
        if temp < 0 {
            tempClothes = "Vinterkläder"
        } else if temp >= 0{
            tempClothes = "Varma kläder"
        } else {
            tempClothes = "Shorts"
        }
        
        var weatherId: String = weather
        weatherId.removeLast(1)
        
        switch weatherId {
        case "01":
            weatherClothes = "solbrillor"
        case "09":
            weatherClothes = "ett paraflax"
        case "10":
            weatherClothes = "ett paraflax"
        case "11":
            weatherClothes = "en åskledare"
        case "13":
            weatherClothes = "snökängor"
        default:
            weatherClothes = "valfri accessoar"
        }
        
        recommendationTempLabel.text = tempClothes
        recommendationWeatherLabel.text = weatherClothes
    }
    
    func animateRecommendation() {
        
        UIView.animate(withDuration: 1.0, animations: {
            self.recommendationBackground.alpha = 1
            self.recommendationBackground.transform = CGAffineTransform(scaleX: 2, y: 2)
        }) { (_) in
            
            UIView.animate(withDuration: 1.0) {
                
                self.recommendationTempLabel.alpha = 1
                self.recommendationHeaderLabel.alpha = 1
                self.recommendationFillerLabel.alpha = 1
                self.recommendationWeatherLabel.alpha = 1
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
    
    static var favourites: [SearchResult] = []
    
    static var cityToDisplay: String?
    
    static func getCityToDisplay() -> String {
        
        return cityToDisplay ?? "Gothenburg"
    }
    
    static func setCityToDisplay(cityName: String) {
        
        self.cityToDisplay = cityName
    }
}

