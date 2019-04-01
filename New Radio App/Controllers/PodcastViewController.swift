//
//  PodcastViewController.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 24/03/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit
import Alamofire
import AVKit

class PodcastViewController: UITableViewController, UISearchBarDelegate {
    
    var podcasts = [Podcast]()
    let celId = "cellId"
    let searchController = UISearchController(searchResultsController: nil)
    var podcastsMain = [Podcast]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupTableView()
        setupSearchBar()
        
        APIService.shared.fetchPodcast { (podcasts) in
            self.podcasts = podcasts
            self.podcastsMain = podcasts
            self.tableView.reloadData()
        }
        
        
        
        //removing separators
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }

    
    fileprivate func buildPodcasts(podcastresults: [Podcast]) {
        self.podcasts = podcastresults
        self.tableView.reloadData()
    
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let podcastsResults = searchPodcasts(index: searchBar.selectedScopeButtonIndex, searchText: searchText)
       
        buildPodcasts(podcastresults: podcastsResults)
        
    }
    
    enum selectedScope: Int {
        case participants = 0
        case description = 1
        case name = 2
        case all = 3
    }
    
    func searchPodcasts(index: Int, searchText: String)->[Podcast]{
       var podcastSearchArray: [Podcast] = []
        
        switch index{
        case selectedScope.name.rawValue:
            for podcast in podcastsMain{
                let myName = podcast.name
                if (myName?.contains(searchText))!{
                    podcastSearchArray.append(podcast)
                }
            }
        case selectedScope.description.rawValue:
            for podcast in podcastsMain{
                let myDescription = podcast.myDescription
                if (myDescription?.contains(searchText))!{
                    podcastSearchArray.append(podcast)
                }
            }
        case selectedScope.participants.rawValue:
            for podcast in podcastsMain{
                let myBroadcasters = podcast.broadcasters
                if (myBroadcasters?.contains(searchText))!{
                    podcastSearchArray.append(podcast)
                }
            }
        case selectedScope.all.rawValue:
            for podcast in podcastsMain{
                let myName = podcast.name
                let myDescription = podcast.myDescription
                let myBroadcasters = podcast.broadcasters
                let myparticipants = podcast.participants
                
                if (myName?.contains(searchText))!{
                    podcastSearchArray.append(podcast)
                } else if (myDescription?.contains(searchText))!{
                    podcastSearchArray.append(podcast)
                }else if (myBroadcasters?.contains(searchText))!{
                    podcastSearchArray.append(podcast)
                }else if (myparticipants?.contains(searchText))!{
                    podcastSearchArray.append(podcast)
                }
            }
     
        default:
            print("no type")
        }
        return podcastSearchArray
    }
    
    fileprivate func setupSearchBar(){
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = ["משתתפים","תיאור", "שם תוכנית", "הכל"]
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        
    }
    
    
    //MARK:- UITableView
    
    fileprivate func setupTableView(){
        //register tables view
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: celId)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive == true && searchController.searchBar.text != ""{
            return podcasts.count
        }
        podcasts = podcastsMain
        return podcastsMain.count
        
    }
    
  
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: celId, for: indexPath) as! PodcastCell
       
        cell.viewCell.layer.borderWidth = 0.5
        cell.viewCell.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        cell.podcastImage.layer.cornerRadius = 10
        
        let podcast = podcasts[indexPath.row]
        cell.podcast = podcast
        
        cell.infoButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.infoButton.layer.cornerRadius = 20
        cell.infoButton.layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        cell.infoButton.tag = indexPath.row
        cell.infoButton.addTarget(self, action: #selector(pushInfoButton), for: .touchUpInside)
        
        // Make it card-like
         cell.viewCell.layer.cornerRadius = 10
         cell.viewCell.layer.shadowOpacity = 1
         cell.viewCell.layer.shadowRadius = 5
         cell.viewCell.layer.shadowColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1).cgColor
         cell.viewCell.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        return cell
    }
    
    @objc func pushInfoButton(_ sender: UIButton){
       let buttonTag = sender.tag
        print("my tag: ", buttonTag)
        let infoViewController = InfoPodcastViewController()
        
        let podcast = podcasts[buttonTag]
        print("The name is... ", podcast.name!)
        
         infoViewController.info = podcast
        
        navigationController?.pushViewController(infoViewController, animated: true)
        
       

    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        
        
        let podcast = self.podcasts[indexPath.row]
        
        let mainTabController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController

        mainTabController?.maximizePlayerDetails(podcast: podcast)
        mainTabController?.minimizePlayerDetails()
        print("didSelectRow(PodcastViewController)", podcast.urlAddress)
        
    
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    

    
}

