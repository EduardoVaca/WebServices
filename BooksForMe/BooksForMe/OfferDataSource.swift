//
//  OfferDataSource.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 20/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import UIKit

class OfferDataSource: NSObject, UITableViewDataSource {
    
    var offers = [Offer]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfferCell", for: indexPath) as! OfferTableViewCell
        
        let offer = offers[indexPath.row]
        cell.titleLabel.text = offer.name
        cell.categoryLabel.text = offer.category
        cell.countryLabel.text = offer.country
        cell.priceLabel.text = "$\(offer.price)"
        return cell
        
    }
}
