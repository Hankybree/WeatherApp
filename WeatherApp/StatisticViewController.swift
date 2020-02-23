//
//  StatisticViewController.swift
//  WeatherApp
//
//  Created by Henrik Frank on 2020-02-23.
//  Copyright © 2020 Henrik Frank. All rights reserved.
//

import UIKit

class StatisticViewController: UIViewController {
    @IBOutlet weak var firstCityLabel: UILabel!
    @IBOutlet weak var secondCityLabel: UILabel!
    @IBOutlet weak var secondCityInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                    
                    self.firstCityLabel.text = "\(weatherData.name) \(tempInt)°C"
                }
            }
        }
    }
    
    @IBAction func compareButtonPressed(_ sender: Any) {
        
        let weatherAPI: WeatherAPI = WeatherAPI()
        
        weatherAPI.getWeatherData(suffix: "weather?q=\(secondCityInput.text ?? "Gothenburg")&units=metric") { (result) in
            
            switch result {
            case .failure(let error):
                print("Error: \(error)")
            case .success(let weatherData):
                
                DispatchQueue.main.async {
                    
                    let tempInt: Int = Int(round(weatherData.main.temp))
                    
                    self.secondCityLabel.text = "\(weatherData.name) \(tempInt)°C"
                }
            }
        }
    }
}
