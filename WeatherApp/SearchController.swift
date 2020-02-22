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
    
    func toDict() -> Dictionary<String, Any> {
        
        let dict = ["name": self.name, "isFavourite": self.isFavourite] as [String : Any]
        
        return dict
    }
}

class SearchController: UIViewController {
    
    @IBOutlet weak var searchTable: UITableView!
    
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    let cellIdentifier: String = "SearchCell"
    
    let cities: [String] = getCityListFromJSON()
    
    var filteredCities: [SearchResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchTable()
        configureSearchController()
        
        self.definesPresentationContext = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.searchController.dismiss(animated: true) {
            self.cancelSearch()
        }
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
        
        cell.favouriteButton.tag = indexPath.row
        cell.favouriteButton.addTarget(self, action: #selector(favouriteButtonPressed(_:)), for: .touchUpInside)
        
        if filteredCities[indexPath.row].isFavourite {
            cell.favouriteButton.isSelected = true
        } else {
            cell.favouriteButton.isSelected = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        CityHandler.setCityToDisplay(cityName: replaceSpaceWithPlus(string: filteredCities[indexPath.row].name))
        
        self.searchController.dismiss(animated: true) {
            self.cancelSearch()
        }
    }
    
    @IBAction func favouriteButtonPressed(_ sender: UIButton) {
        
        let chosenCity: SearchResult = filteredCities[sender.tag]
        
        if chosenCity.isFavourite {
            setIsFavourite(chosenCity: chosenCity, index: sender.tag, bool: false)
            
            for i in 0..<CityHandler.favourites.count {
                
                if chosenCity.name == CityHandler.favourites[i].name {
                    CityHandler.favourites.remove(at: i)
                    break
                }
            }
        } else {
            setIsFavourite(chosenCity: chosenCity, index: sender.tag, bool: true)
            
            CityHandler.favourites.append(chosenCity)
        }
        
        saveFavourites()
        
        searchTable.reloadData()
    }
    
    func setIsFavourite(chosenCity: SearchResult, index: Int, bool: Bool) {
        for i in 0..<CityHandler.searchResults.count {
            if chosenCity.name == CityHandler.searchResults[i].name {
                filteredCities[index].isFavourite = bool
                CityHandler.searchResults[i].isFavourite = bool
            }
        }
    }
}

extension SearchController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchText = searchController.searchBar.text ?? ""
        
        filteredCities = CityHandler.searchResults.filter( { $0.name.lowercased().hasPrefix(searchText.lowercased()) })
        
        searchTable.reloadData()
    }
    
    func cancelSearch() {
        
        self.definesPresentationContext = false
        
        self.searchController.isActive = false
        self.navigationController?.popViewController(animated: true)
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

