//
//  ChatCell.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 29/03/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit

class ChatListCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var podcastImage: UIImageView!
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var favoritesNameLabel: UILabel!
    @IBOutlet weak var imageChat: UIImageView!
    
    var podcast: Podcast!{
        didSet{
            favoritesNameLabel.text = podcast.name
            podcastImage.image = podcast.imageLocal
            
        }
    }
}
