//
//  PodcastCell.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 24/03/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit

class PodcastCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var podcastImage: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    
    var podcast: Podcast?{
        didSet{
           trackNameLabel.text = podcast?.name
            podcastImage.image = podcast?.imageLocal
            
        }
    }

    
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        
    }
}
