//
//  FavoritePodcastCell.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 25/03/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit


/*
 This View done through code
 */
class FavoritePodcastCell: UICollectionViewCell {
    
    var podcast: Podcast!{
        didSet{
            nameLabel.text = podcast.name
            descriptionLabel.text = podcast.myDescription
            
        }
    }
    
    let imageView = UIImageView(image: UIImage(named: "pod"))
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        stylizeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel, descriptionLabel])
        
        stackView.axis = .vertical
        // enables auto layout
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    fileprivate func stylizeUI() {
        //nameLabel.text = "Podcast Name"
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        descriptionLabel.text = "Artist Name"
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .lightGray
    }
    
}
