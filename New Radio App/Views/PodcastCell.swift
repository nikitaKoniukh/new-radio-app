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
    
    @IBOutlet weak var podcastImage: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var trackDescriptionLabel: UILabel!
    
    var podcast: Podcast!{
        didSet{
            trackNameLabel.text = podcast.name
            trackDescriptionLabel.text = podcast.myDescription
        }
    }

}
