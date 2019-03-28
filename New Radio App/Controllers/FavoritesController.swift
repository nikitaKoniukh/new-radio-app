//
//  FavoritesViewController.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 25/03/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit


class FavoritesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellId"
    
    var podcasts = UserDefaults.standard.savePodcasts()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        podcasts = UserDefaults.standard.savePodcasts()
        collectionView.reloadData()
        UIApplication.mainTabController()?.viewControllers?[0].tabBarItem.badgeValue = nil
    }
    
    fileprivate func setupCollectionView() {
        collectionView?.backgroundColor = .white
        collectionView?.register(FavoritePodcastCell.self, forCellWithReuseIdentifier: cellId)
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView?.addGestureRecognizer(gesture)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        //        print("Captured Long Press")
        
        let location = gesture.location(in: collectionView)
        
        guard let selectedIndexPath = collectionView?.indexPathForItem(at: location) else { return }
        
        print(selectedIndexPath.item)
        
        let alertController = UIAlertController(title: "הסר פודקאסט?", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "כן", style: .destructive, handler: { (_) in
            let selectedPodcast = self.podcasts[selectedIndexPath.item]
            // where we remove the podcast object from collection view
            self.podcasts.remove(at: selectedIndexPath.item)
            self.collectionView?.deleteItems(at: [selectedIndexPath])
            // also remove your favorited podcast from UserDefaults
            // The simulator doesn't delete immediately, test with your physical iPhone devices
            UserDefaults.standard.deletePodcast(podcast: selectedPodcast)
        }))
        
        alertController.addAction(UIAlertAction(title: "בטל", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    // MARK:- UICollectionView Delegate / Spacing Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FavoritePodcastCell
        
        cell.podcast = self.podcasts[indexPath.item]
        
        return cell
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        
        let podcast = self.podcasts[indexPath.row]
        
        let mainTabController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
         mainTabController?.maximizePlayerDetails(podcast: podcast)
   
//
//        if player.timeControlStatus == .paused{
//            mainTabController?.maximizePlayerDetails(podcast: podcast)
//            player.play()
//           mainTabController?.playerDetailsView.playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
//           // miniPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
//           // enlargePodcastImageView()
//            //self.setupElapsedTime(playBackRate: 1)
//        }else{
//            player.pause()
//            mainTabController?.maximizePlayerDetails(podcast: podcast)
//            mainTabController?.playerDetailsView.playPauseButton.setImage(UIImage(named: "play"), for: .normal)        //miniPlayPauseButton.setImage(UIImage(named: "play"), for: .normal)
//           // shrinkPodcastImageView()
//            //self.setupElapsedTime(playBackRate: 0)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 3 * 16) / 2
        
        return CGSize(width: width, height: width + 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    
    
    
    
    
}
