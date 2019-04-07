//
//  FavoritesCell.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 31/03/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit

class FavoritesCell: UITableViewCell {
    
    @IBOutlet weak var podcastImage: UIImageView!
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var favoritesNameLabel: UILabel!
    
    var podcast: Podcast!{
        didSet{
            favoritesNameLabel.text = podcast.name
            podcastImage.image = podcast.imageLocal
           
        }
    }
}
