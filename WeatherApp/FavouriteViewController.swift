//
//  FavouriteViewController.swift
//  WeatherApp
//
//  Created by Henrik Frank on 2020-02-19.
//  Copyright © 2020 Henrik Frank. All rights reserved.
//

import UIKit

class FavouriteViewController: UIViewController {

    @IBOutlet weak var favouriteTable: UITableView!
    
    var favourites: [SearchResult] = []
    
    let cellIdentifier: String = "SearchCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favouriteTable.delegate = self
        favouriteTable.dataSource = self
        
        favouriteTable.register(SearchCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        for i in 0..<CityHandler.searchResults.count {
            
            if CityHandler.searchResults[i].isFavourite {
                
                if !favourites.contains(where: { ($0.name == CityHandler.searchResults[i].name) }) {
                    
                    favourites.append(SearchResult(name: CityHandler.searchResults[i].name, isFavourite: CityHandler.searchResults[i].isFavourite))
                }
            }
        }
        
        favouriteTable.reloadData()
    }
}

extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchCell
        
        cell.set(cityName: favourites[indexPath.row].name)
        
        cell.favouriteButton.tag = indexPath.row
        cell.favouriteButton.addTarget(self, action: #selector(favouriteButtonPressed(_:)), for: .touchUpInside)
        
        if favourites[indexPath.row].isFavourite {
            cell.favouriteButton.isSelected = true
        } else {
            cell.favouriteButton.isSelected = false
        }
        
        return cell
    }
    
    @IBAction func favouriteButtonPressed(_ sender: UIButton) {
        
        let chosenCity: SearchResult = favourites[sender.tag]
        
        if chosenCity.isFavourite {
            setIsFavourite(chosenCity: chosenCity, index: sender.tag, bool: false)
            favourites.remove(at: sender.tag)
        } else {
            setIsFavourite(chosenCity: chosenCity, index: sender.tag, bool: true)
        }
        
        favouriteTable.reloadData()
    }
    
    func setIsFavourite(chosenCity: SearchResult, index: Int, bool: Bool) {
        for i in 0..<CityHandler.searchResults.count {
            if chosenCity.name == CityHandler.searchResults[i].name {
                favourites[index].isFavourite = bool
                CityHandler.searchResults[i].isFavourite = bool
            }
        }
    }
}
