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
        cell.viewCell.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).cgColor
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "הוסף כמה פודקאסטים המועדפים"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.podcasts.count > 0 ? 0 : 250
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        
        animateTable()
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
    
}
