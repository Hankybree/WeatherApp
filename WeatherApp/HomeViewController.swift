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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

extension HomeViewController: UISearchBarDelegate {
    
    
}

