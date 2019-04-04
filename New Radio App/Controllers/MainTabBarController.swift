//
//  MainTabBarController.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 24/03/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tabBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        setupViewControllers()
        setupPlayerDetailViiew()
        
    }
    
    //MARK:- Helper Function
    
  fileprivate  func setupViewControllers(){
//    
//    let layout = UICollectionViewFlowLayout()
//    let favoritesController = FavoritesController(collectionViewLayout: layout)
    
        viewControllers = [
            generateNavController(with: PodcastViewController(), title: "פודקאסטים", image: UIImage(named: "playlist")!),
            generateNavController(with: FavoritesController(), title: "מועדפים", image: UIImage(named: "like")!),
//            generateNavController(with: ViewController(), title: "חיפוש", image: UIImage(named: "search")!),
//            generateNavController(with: ViewController(), title: "התגים שלי", image: UIImage(named: "hashtag")!),
            generateNavController(with: ChatListViewController(), title: "המשובים שלי", image: UIImage(named: "chat")!)
        ]
    }
    
    
    fileprivate func generateNavController(with rootViewController: UIViewController, title: String, image: UIImage)->UIViewController{
        
        let navController = UINavigationController(rootViewController: rootViewController)
        
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
    
        let imageProfile = UIImage(named: "profile")
        let nav = navController.navigationBar
        nav.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        rootViewController.navigationItem.title = title
        
        rootViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageProfile, style: .plain, target: self, action: #selector(profileBtn))
        
        return navController
    }
    
    @objc func profileBtn(){
                let profileViewController = ProfileViewController()

               navigationController?.pushViewController(profileViewController, animated: true)
        

    }
    
    
    
    let playerDetailsView = PlayerDetaislView.initFromNib()
    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var minimizedTopAnchorConstraint: NSLayoutConstraint!
    var bottomAnchorConstraint: NSLayoutConstraint!
    
    fileprivate func setupPlayerDetailViiew(){
        print("Setting up PlayerDetailsView")
        
        
        // use auto layout
        //        view.addSubview(playerDetailsView)
        view.insertSubview(playerDetailsView, belowSubview: tabBar)
        
        // enables auto layout
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTopAnchorConstraint.isActive = true
        
        bottomAnchorConstraint = playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        
        minimizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -58)
        //        minimizedTopAnchorConstraint.isActive = true
        
        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

    }
    
    @objc func minimizePlayerDetails(){
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            
            //to comeback tabbar
            self.tabBar.transform = .identity
            
            self.playerDetailsView.maximizedStackView.alpha = 0
            self.playerDetailsView.minimizedStackView.alpha = 1
        })
    }
    
    func  maximizePlayerDetails(podcast: Podcast?){
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        if podcast != nil{
            playerDetailsView.podcast = podcast
            
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            
            //dismiss tabbar
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            
            self.playerDetailsView.maximizedStackView.alpha = 1
            self.playerDetailsView.minimizedStackView.alpha = 0
        })
    }
}
