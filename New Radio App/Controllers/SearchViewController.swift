//
//  SearchViewController.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 24/03/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    let celId = "cellId"
    let podcasts = [Podcast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register tables view
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: celId)
        
        setupSearchBar()
        
    }
    
    //MARK:- Setup Work
    fileprivate func setupSearchBar(){
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
//            APIService.shared.fetchPodcast(searchText: searchText) { (podcast) in
//                self.podcast = podcast
//                self.tableView.reloadData()
//            }
//        })
    }
    
    
    
    //MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: celId, for: indexPath)
        
        let podcast = podcasts[indexPath.row]
       // cell.textLabel?.text = "\(podcast.name)\n\(podcast.description)"
        cell.textLabel?.numberOfLines = -1
        //cell.imageView?.image = UIImage(named: "pod")
        
        return cell
    }
    
}
