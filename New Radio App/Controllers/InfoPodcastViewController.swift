//
//  InfoPodcastViewController.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 31/03/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit



class InfoPodcastViewController: UIViewController {
    
    //Outlets

    @IBOutlet weak var nameInfoLabel: UILabel!
    @IBOutlet weak var descriptionInfoLabel: UILabel!
    @IBOutlet weak var broadcastersInfoLabel: UILabel!
    @IBOutlet weak var paticipantsInfoLabel: UILabel!
    
    var nameLocal: String?
    var descriptionLocal: String?
    var broadcastersLocalArray = [String]()
    var brodcasterLocal: String?
    var participantsLocalArray = [String]()
    var participantsLocal: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameInfoLabel.text = nameLocal
        descriptionInfoLabel.text = descriptionLocal
        broadcastersInfoLabel.text = brodcasterLocal
        paticipantsInfoLabel.text = participantsLocal
   
       
      print(brodcasterLocal)
        
    }

    var info: Podcast?{
        didSet{
            nameLocal = info?.name
            descriptionLocal = info?.myDescription
            
            broadcastersLocalArray = (info?.broadcasters)!
            brodcasterLocal = broadcastersLocalArray.joined(separator: ", ")
            
            participantsLocalArray = (info?.participants)!
            participantsLocal = participantsLocalArray.joined(separator: ", ")
            
            
          
        }
    }


}


