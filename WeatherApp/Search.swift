//
//  Sort.swift
//  WeatherApp
//
//  Created by Henrik Frank on 2020-02-06.
//  Copyright © 2020 Henrik Frank. All rights reserved.
//

import Foundation

func getCityListFromJSON() -> [String] {
    
    let fileName: String = "sortedcitylist"
    
    do {
    
        if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
        
            let data = try Data.init(contentsOf: file)
            
            let decoder = JSONDecoder()
            
            let cityList: [String] = try decoder.decode([String].self, from: data)
            
            return cityList
        }
    } catch {
        
        print("Error with reading json")
    }
    
    return [String]()
}

