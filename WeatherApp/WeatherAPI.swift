//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Henrik Frank on 2020-02-04.
//  Copyright © 2020 Henrik Frank. All rights reserved.
//

import Foundation

struct WeatherData : Codable {
    let main: Temp
    let name: String
    let weather: [Weather]
}

struct Temp : Codable {
    let temp: Float
}

struct Weather : Codable {
    let icon: String
}

struct WeatherAPI {
    
    let baseURL: String = "http://api.openweathermap.org/data/2.5/"
    let apiKey: String = "&APPID=47abdc540c57752c9db7e4d6ebdf36ad"
    
    func getWeatherData(suffix: String, completion: @escaping(Result<WeatherData,Error>) -> Void) {
        
        let urlString: String = baseURL + suffix + apiKey
        
        guard let url: URL = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let unwrappedError = error {
                
                print("Something went wrong with request. Error: \(unwrappedError)")
                return
            }
            if let unwrappedData = data {
                
                do {
                    let decoder = JSONDecoder()
                    
                    let weatherData: WeatherData = try decoder.decode(WeatherData.self, from: unwrappedData)
                    
                    completion(.success(weatherData))
                } catch {
                    
                    print("Coudn't read weather data")
                }
            }
        }
        task.resume()
    }
}
