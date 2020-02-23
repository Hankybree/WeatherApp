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
    
    let cellIdentifier: String = "SearchCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favouriteTable.delegate = self
        favouriteTable.dataSource = self
        
        favouriteTable.register(SearchCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        favouriteTable.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveFavourites()
    }
}

extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CityHandler.favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchCell
        
        cell.set(cityName: CityHandler.favourites[indexPath.row].name)
        
        cell.favouriteButton.tag = indexPath.row
        cell.favouriteButton.addTarget(self, action: #selector(favouriteButtonPressed(_:)), for: .touchUpInside)
        
        cell.favouriteButton.isSelected = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        CityHandler.setCityToDisplay(cityName: replaceSpaceWithPlus(string: CityHandler.favourites[indexPath.row].name))
        
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func favouriteButtonPressed(_ sender: UIButton) {
        
        let chosenCity: SearchResult = CityHandler.favourites[sender.tag]
        
        if chosenCity.isFavourite {
            setIsFavourite(chosenCity: chosenCity, index: sender.tag, bool: false)
            CityHandler.favourites.remove(at: sender.tag)
        } else {
            setIsFavourite(chosenCity: chosenCity, index: sender.tag, bool: true)
        }
        
        favouriteTable.reloadData()
    }
    
    func setIsFavourite(chosenCity: SearchResult, index: Int, bool: Bool) {
        for i in 0..<CityHandler.searchResults.count {
            if chosenCity.name == CityHandler.searchResults[i].name {
                CityHandler.favourites[index].isFavourite = bool
                CityHandler.searchResults[i].isFavourite = bool
            }
        }
    }
}

func saveFavourites() {
    
    let settings = UserDefaults.standard
    
    var saveableFavourites: [Dictionary<String, Any>] = []
    
    for i in 0..<CityHandler.favourites.count {
        
        saveableFavourites.append(CityHandler.favourites[i].toDict())
    }
    
    settings.set(saveableFavourites, forKey: "favourites")
}

func loadFavourites() {
    
    let settings = UserDefaults.standard
    
    if settings.array(forKey: "favourites") != nil {
        let loadableFavourites: [Dictionary<String, Any>] = settings.array(forKey: "favourites") as! [Dictionary<String, Any>]
        
        for i in 0..<loadableFavourites.count {
            
            CityHandler.favourites.append(SearchResult(name: loadableFavourites[i]["name"] as! String, isFavourite: (loadableFavourites[i]["isFavourite"] != nil)))
        }
    }
}
