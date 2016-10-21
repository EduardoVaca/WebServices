//
//  InitialViewController.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 21/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    @IBAction func showSearch(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "ShowSearch", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSearch" {
            // Pass a new BookStore to the SearchVC
            let rootViewController = segue.destination as! UINavigationController
            let searchBooksViewController = rootViewController.topViewController as! SearchBooksViewController
            searchBooksViewController.bookStore = BookStore()

        }
    }
    
    
}
