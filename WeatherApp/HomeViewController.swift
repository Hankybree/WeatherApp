//
//  ViewController.swift
//  WeatherApp
//
//  Created by Henrik Frank on 2020-02-03.
//  Copyright © 2020 Henrik Frank. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let cityList: [String] = getCityListFromJSON()
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var celsiusLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        City.setCityToDisplay(cityName: "London")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let cityName = City.getCityToDisplay()
        
        let weatherAPI: WeatherAPI = WeatherAPI()
        
        weatherAPI.getWeatherData(suffix: "weather?q=\(cityName)&units=metric") { (result) in
            
            switch result {
            case .failure(let error):
                print("Error: \(error)")
            case .success(let weatherData):
                
                DispatchQueue.main.async {
                    //print("Temperature in \(weatherData.name) is \(kelvinToCelsiusWithTwoPoints(kelvin: weatherData.main.temp))")
                    print("Temperature in \(weatherData.name) is \(round(weatherData.main.temp))")
                    
                    self.cityLabel.text = weatherData.name
                    
                    let tempInt: Int = Int(round(weatherData.main.temp))
                    
                    self.celsiusLabel.text = "\(tempInt) C"
                }
            }
        }
    }
    
    @IBAction func getLocation(_ sender: Any) {
        
        /*let weatherAPI: WeatherAPI = WeatherAPI()
        
        let userInput: String? = input.text
        
        weatherAPI.getWeatherData(suffix: "weather?q=\(userInput ?? "London")") { (result) in
            
            switch result {
            case .failure(let error):
                print("Error: \(error)")
            case .success(let weatherData):
                
                DispatchQueue.main.async {
                    print("Temperature in \(weatherData.name) is \(kelvinToCelsiusWithTwoPoints(kelvin: weatherData.main.temp))")
                }
            }
        }*/
    }
}

class City {
    
    static var cityToDisplay: String?
    
    static func getCityToDisplay() -> String {
        
        return cityToDisplay ?? "Gothenburg"
    }
    
    static func setCityToDisplay(cityName: String) {
        
        self.cityToDisplay = cityName
    }
}

