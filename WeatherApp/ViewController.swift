//
//  ViewController.swift
//  WeatherApp
//
//  Created by Henrik Frank on 2020-02-03.
//  Copyright © 2020 Henrik Frank. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var input: UITextField!
    
    
    @IBAction func getLocation(_ sender: Any) {
        
        print("Button pressed")
        
        let weatherAPI: WeatherAPI = WeatherAPI()
        
        let userInput: String? = input.text
        
        weatherAPI.getWeatherData(suffix: "weather?q=\(userInput ?? "London")") { (result) in
            
            switch result {
            case .failure(let error):
                print("Error: \(error)")
            case .success(let weatherData):
                
                DispatchQueue.main.async {
                    self.label.text = "Temperature in \(weatherData.name) is \(kelvinToCelsiusWithTwoPoints(kelvin: weatherData.main.temp))"
                }
            }
        }
    }
}

