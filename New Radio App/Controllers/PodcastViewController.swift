//
//  PodcastViewController.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 24/03/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit
import Alamofire

class PodcastViewController: UITableViewController {
    
    var podcasts = [Podcast]()
    let celId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        
            APIService.shared.fetchPodcast { (podcasts) in
            self.podcasts = podcasts
            self.tableView.reloadData()
        }
        
      
    }
    
    
    //MARK:- UITableView
    
    fileprivate func setupTableView(){
        //register tables view
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: celId)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: celId, for: indexPath) as! PodcastCell
        
        let podcast = podcasts[indexPath.row]
        cell.podcast = podcast
//
//        cell.textLabel?.text = "\(podcast.name ?? "")\n\(podcast.description ?? "")"
//        cell.textLabel?.numberOfLines = -1
//        //cell.imageView?.image = UIImage(named: "pod")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let podcast = self.podcasts[indexPath.row]
        let playerButton = PlayerDetaislView()
        
        let mainTabController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
       
        mainTabController?.maximizePlayerDetails(podcast: podcast)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
}
