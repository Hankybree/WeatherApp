//
//  Cells.swift
//  WeatherApp
//
//  Created by Henrik Frank on 2020-02-18.
//  Copyright © 2020 Henrik Frank. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    var cityLabel = UILabel()
    var favouriteButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(cityLabel)
        addSubview(favouriteButton)
        
        configureCityLabel()
        
        setCityLabelConstraints()
        setFavouriteButtonConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(cityName: String) {
        cityLabel.text = cityName
        
        favouriteButton.setImage(UIImage(systemName: "star"), for: UIControl.State.normal)
        favouriteButton.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.selected)
    }
    
    func configureCityLabel() {
        cityLabel.numberOfLines = 0
        cityLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setCityLabelConstraints() {
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
    }
    
    func setFavouriteButtonConstraints() {
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        favouriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
    }
}
