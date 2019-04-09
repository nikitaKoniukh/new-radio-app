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
    @IBOutlet weak var saveToFavoritesButton: UIButton!
    @IBOutlet weak var leaveFeedbackButton: UIButton!
    
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
        
        buttonLayoutSetup(saveToFavoritesButton)
        buttonLayoutSetup(leaveFeedbackButton)
    }
    
    
    
    func buttonLayoutSetup(_ button: UIButton){
        button.layer.cornerRadius = 10
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 2
        button.layer.shadowColor = #colorLiteral(red: 0.7157995162, green: 0.7157995162, blue: 0.7157995162, alpha: 1).cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
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
   

    @IBAction func seveToFavoritesButtonPressed(_ sender: UIButton) {
        switch info!.isFavorites {
        case true:
            info!.isFavorites = false
            // favBtn.setImage(UIImage(named: "icons8-hearts2"), for: .normal)
            
        case false:
            info!.isFavorites = true
           // favBtn.setImage(UIImage(named: "like"), for: .normal)
            addToFavorites()
        }
        //animate button
        let bounds = sender.bounds
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            sender.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 40, height: bounds.size.height)
        }) { (success:Bool) in
            if success {
                
                UIView.animate(withDuration: 0.5, animations: {
                    sender.bounds = bounds
                })
            }
        }
    }
    
    @IBAction func leaveFeedbackButtonPressed(_ sender: UIButton) {
        switch info!.isFeedbackOn {
        case true:
            info!.isFeedbackOn = false
            
        case false:
            
            addToFeedback()
            
            info!.isFeedbackOn = true
        }
        
        //animate button
        let bounds = sender.bounds
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            sender.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 40, height: bounds.size.height)
        }) { (success:Bool) in
            if success {
                
                UIView.animate(withDuration: 0.5, animations: {
                    sender.bounds = bounds
                })
            }
        }
    }
    
    
    fileprivate func addToFavorites() {
        //let's check if we have already saved this podcast as fav
        let savedPodcasts = UserDefaults.standard.savePodcasts()
        let hasFavorited = savedPodcasts.index(where: { $0.name == self.info?.name }) != nil
        if hasFavorited {
        } else {
            guard let podcast = self.info else {return}
            var listOfPodcasts = UserDefaults.standard.savePodcasts()
            listOfPodcasts.append(podcast)
            let data = try! NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritePodcastKey)
            showBadgeHighlight()
        }
    }
    
    fileprivate func addToFeedback() {
        //let's check if we have already saved this podcast as fav
        let savedFeedbacks = UserDefaults.standard.saveFeedback()
        let hasFavorited = savedFeedbacks.index(where: { $0._id == self.info?._id }) != nil
        if hasFavorited {
        } else {
            guard let podcast = self.info else {return}
            var listOfPodcasts = UserDefaults.standard.saveFeedback()
            listOfPodcasts.append(podcast)
            let data = try! NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: UserDefaults.feedbackPodcastKey)
            showBadgeFeedback()
        }
    }
    
    
    fileprivate func showBadgeFeedback(){
        UIApplication.mainTabController()?.viewControllers?[2].tabBarItem.badgeValue = "feedback"
    }
    
    
    fileprivate func showBadgeHighlight(){
        UIApplication.mainTabController()?.viewControllers?[1].tabBarItem.badgeValue = "חדש"
    }
}


