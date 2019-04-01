//
//  FavoritesViewController.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 25/03/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit


class FavoritesController:UITableViewController {
    
    var podcasts = [Podcast]()
    let celId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
 
        
        //removing separators
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        podcasts = UserDefaults.standard.savePodcasts()
        tableView.reloadData()
        UIApplication.mainTabController()?.viewControllers?[1].tabBarItem.badgeValue = nil
    }
    
    //MARK:- UITableView
    
    fileprivate func setupTableView(){
        //register tables view
        let nib = UINib(nibName: "FavoritesCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: celId)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: celId, for: indexPath) as! FavoritesCell
        
        cell.viewCell.layer.borderWidth = 0.5
        cell.viewCell.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        cell.podcastImage.layer.cornerRadius = 5
        
        let podcast = podcasts[indexPath.row]
        cell.podcast = podcast
        
        
        // Make it card-like
        cell.viewCell.layer.cornerRadius = 5
        cell.viewCell.layer.shadowOpacity = 1
        cell.viewCell.layer.shadowRadius = 5
        cell.viewCell.layer.shadowColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1).cgColor
        cell.viewCell.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let podcast = self.podcasts[indexPath.row]
        //  let playerButton = PlayerDetaislView()
        
        let mainTabController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        
        mainTabController?.maximizePlayerDetails(podcast: podcast)
        mainTabController?.minimizePlayerDetails()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            let selectedPodcast = self.podcasts[indexPath.row]
            podcasts.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            UserDefaults.standard.deletePodcast(podcast: selectedPodcast)
            tableView.endUpdates()
        }
    }
    
    
    
}






















//
//
//
//
//
//UICollectionViewController, UICollectionViewDelegateFlowLayout {
//    
//    fileprivate let cellId = "cellId"
//    
//    var podcasts = UserDefaults.standard.savePodcasts()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupCollectionView()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        podcasts = UserDefaults.standard.savePodcasts()
//        collectionView.reloadData()
//        UIApplication.mainTabController()?.viewControllers?[0].tabBarItem.badgeValue = nil
//    }
//    
//    fileprivate func setupCollectionView() {
//        collectionView?.backgroundColor = .white
//        collectionView?.register(FavoritePodcastCell.self, forCellWithReuseIdentifier: cellId)
//        
//        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
//        collectionView?.addGestureRecognizer(gesture)
//    }
//    
//    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
//        //        print("Captured Long Press")
//        
//        let location = gesture.location(in: collectionView)
//        
//        guard let selectedIndexPath = collectionView?.indexPathForItem(at: location) else { return }
//        
//        print(selectedIndexPath.item)
//        
//        let alertController = UIAlertController(title: "הסר פודקאסט?", message: nil, preferredStyle: .actionSheet)
//        
//        alertController.addAction(UIAlertAction(title: "כן", style: .destructive, handler: { (_) in
//            let selectedPodcast = self.podcasts[selectedIndexPath.item]
//            // where we remove the podcast object from collection view
//            self.podcasts.remove(at: selectedIndexPath.item)
//            self.collectionView?.deleteItems(at: [selectedIndexPath])
//            // also remove your favorited podcast from UserDefaults
//            // The simulator doesn't delete immediately, test with your physical iPhone devices
//            UserDefaults.standard.deletePodcast(podcast: selectedPodcast)
//        }))
//        
//        alertController.addAction(UIAlertAction(title: "בטל", style: .cancel))
//        
//        present(alertController, animated: true)
//    }
//    
//    // MARK:- UICollectionView Delegate / Spacing Methods
//    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return podcasts.count
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FavoritePodcastCell
//        
//        cell.podcast = self.podcasts[indexPath.item]
//        
//        return cell
//    }
//    
//
//    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//       
//        
//        let podcast = self.podcasts[indexPath.row]
//        
//        let mainTabController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
//         mainTabController?.maximizePlayerDetails(podcast: podcast)
//   
///
//    
//}
