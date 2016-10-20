//
//  Offer.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 20/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import Foundation


class Offer {
    
    let name: String!
    let category: String!
    let country: String!
    let price: Float!
    
    init(name: String, category: String, country: String, price: Float) {
        self.name = name
        self.category = category
        self.country = country
        self.price = price
    }
}
