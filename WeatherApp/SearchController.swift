//
//  Sort.swift
//  WeatherApp
//
//  Created by Henrik Frank on 2020-02-06.
//  Copyright © 2020 Henrik Frank. All rights reserved.
//

import Foundation
import UIKit

struct SearchResult {
    let name: String
    var isFavourite: Bool
}

class SearchController: UIViewController {
    
    @IBOutlet weak var searchTable: UITableView!
    
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    let cellIdentifier: String = "SearchCell"
    
    let cities: [String] = getCityListFromJSON()
    
    var searchResults: [SearchResult] = []
    
    var filteredCities: [SearchResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<cities.count {
            
            if cities[i] != "" {
                searchResults.append(SearchResult(name: cities[i], isFavourite: false))
            }
        }
        
        configureSearchTable()
        configureSearchController()
    }
    
    func configureSearchTable() {
        searchTable.delegate = self
        searchTable.dataSource = self
        
        searchTable.tableHeaderView = searchController.searchBar
        
        searchTable.register(SearchCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
}

extension SearchController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchCell
        
        cell.set(cityName: filteredCities[indexPath.row].name)
        
        if filteredCities[indexPath.row].isFavourite {
            cell.favouriteButton.isSelected = true
        } else {
            cell.favouriteButton.isSelected = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        CurrentCity.setCityToDisplay(cityName: replaceSpaceWithPlus(string: filteredCities[indexPath.row].name))
        
        self.searchController.isActive = false
        navigationController?.popViewController(animated: true)
    }
    
}

extension SearchController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchText = searchController.searchBar.text ?? ""
        
        filteredCities = searchResults.filter( { $0.name.lowercased().hasPrefix(searchText.lowercased()) })
        
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

func replaceSpaceWithPlus(string: String) -> String {
    
    let cityName = string.replacingOccurrences(of: " ", with: "+")
    
    return cityName
}

