//
//  PodcastViewController.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 24/03/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit
import AVKit
import BMSCore
import BMSPush
import UserNotifications
import IBMCloudAppID
import Reachability


class PodcastViewController: UITableViewController, UISearchBarDelegate {

    var podcasts = [Podcast]()
    let celId = "cellId"
    let searchController = UISearchController(searchResultsController: nil)
    var podcastsMain = [Podcast]()
    let reachability = Reachability()!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setReachabilityNotifire()
    
        let content = UNMutableNotificationContent()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "testIdentifire", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
       
        
        imageArrayRandom()
       // setupTableView()
        setupSearchBar()
       
        setupTableView()
        // setupPushNotification()
   
        APIService.shared.fetchPodcast { (podcasts) in
            self.podcasts = podcasts
            self.podcastsMain = podcasts
            //sort podcasts by date
            let podcastSorted = self.podcastsMain.sorted(by: { ($0.timestamp ?? 0) > ($1.timestamp ?? 1) })
            self.podcastsMain = podcastSorted
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
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
       let podcastsResults = searchPodcasts(index: selectedScope, searchText: searchController.searchBar.text ?? "")
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
      
        searchController.searchBar.selectedScopeButtonIndex = 3
        searchController.searchBar.scopeButtonTitles = ["משתתפים","תיאור", "שם תוכנית", "הכל"]
        navigationController?.hidesBarsOnSwipe = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
    }
    
  
    
    //format time
    func getTime(timestamp: TimeInterval) -> String{
        let date: NSDate! = NSDate(timeIntervalSince1970: timestamp/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy HH:mm"
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date as Date)
        
        return timeStamp
    }
    
    //MARK:- UITableView
    
    fileprivate func setupTableView(){
        //register tables view
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: celId)
    }
   
    var time = [String]()
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

        cell.infoButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.infoButton.layer.cornerRadius = 20
        cell.infoButton.layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        cell.infoButton.tag = indexPath.row
        cell.infoButton.addTarget(self, action: #selector(pushInfoButton), for: .touchUpInside)
        
        // Make it card-like
         cell.viewCell.layer.cornerRadius = 10
         cell.viewCell.layer.shadowOpacity = 1
         cell.viewCell.layer.shadowRadius = 5
         cell.viewCell.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
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
        
        
        navigationController?.pushViewController(infoViewController, animated: false)

    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let podcast = self.podcasts[indexPath.row]
        let mainTabController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController

        mainTabController?.maximizePlayerDetails(podcast: podcast)
        mainTabController?.minimizePlayerDetails()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        activityIndicator.startAnimating()
        return activityIndicator
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return podcasts.isEmpty ? 200 : 0
    }
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        animateTable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(false)
    }

    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
        
        
    }
    
    //MARK: - check internet connection
    func setReachabilityNotifire(){
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        }catch{
            print("coul'd atart reachability notifire")
        }
    }
    
    @objc func reachabilityChanged(note: Notification){
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            print("wifi!!!!!!!!!!!!!!!")
        case .cellular:
            print("celular!!!!!!!!!!!!!!!")
        case .none:
            print("no!!!!!!!!!!!!!!!")
            self.alert(message: "מצטערים, אין חיבור לאינטרנט", title: "Oops!")
        }
    }
    
}
extension PodcastViewController{
    func alert (message: String, title: String = ""){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "בסדר", style: .default, handler: nil)
        alertController.addAction(okAction)

        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

