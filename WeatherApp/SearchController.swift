//
//  Sort.swift
//  WeatherApp
//
//  Created by Henrik Frank on 2020-02-06.
//  Copyright © 2020 Henrik Frank. All rights reserved.
//

import Foundation
import UIKit

class SearchController: UIViewController {
    
    @IBOutlet weak var searchTable: UITableView!
    
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    let cities: [String] = getCityListFromJSON()
    
    var filteredCities: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTable.delegate = self
        searchTable.dataSource = self
        
        searchController.searchResultsUpdater = self
        
        searchTable.tableHeaderView = searchController.searchBar
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
}

extension SearchController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        
        cell.textLabel?.text = filteredCities[indexPath.row]
        
        return cell
    }
    
    
    
}

extension SearchController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchText = searchController.searchBar.text ?? ""
        
        filteredCities = cities.filter( { $0.lowercased().hasPrefix(searchText.lowercased()) } )
        
        searchTable.reloadData()
    }
}

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

