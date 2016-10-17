//
//  BookTableViewCell.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 17/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    @IBOutlet var bookImage: UIImageView!
    @IBOutlet var bookName: UILabel!
    @IBOutlet var authorName: UILabel!
    @IBOutlet var rating: UILabel!
    @IBOutlet var year: UILabel!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    func updateWithImage(image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            bookImage.image = imageToDisplay
        }
        else {
            spinner.startAnimating()
            bookImage.image = nil
        }
    }
    
    // So that in the beginning the image will be loading
    override func awakeFromNib() {
        super.awakeFromNib()
        updateWithImage(image: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateWithImage(image: nil)
    }
}
