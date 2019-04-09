//
//  ChatListViewController.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 29/03/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit
import IBMCloudAppID
import BMSCore
import BMSPush
import UserNotifications
import FirebaseDatabase

class ChatListViewController: UITableViewController, AuthorizationDelegate {
    var podcasts = [Podcast]()
    let cellId = "cellId"
    let cell = UITableViewCell()
    var ref: DatabaseReference?
    let alert = CustomAlert(title: "ספר לנו, מה שמך", image: UIImage(named: "pod")!)


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        podcasts = UserDefaults.standard.saveFeedback()
        tableView.reloadData()
        UIApplication.mainTabController()?.viewControllers?[2].tabBarItem.badgeValue = nil
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if UserDefaults.standard.string(forKey: "UserNameLogin") == nil || UserDefaults.standard.string(forKey: "UserNameLogin") == ""{
            
            alert.show(animated: true)
        }
        if UserDefaults.standard.string(forKey: "myUserID") == nil{
           
            alert.show(animated: true)
            AppID.sharedInstance.signinAnonymously(authorizationDelegate: self)
            //AppID.sharedInstance.loginWidget?.launch(delegate: self)
        }else if UserDefaults.standard.string(forKey: "myUserID") != nil{
           
        }
        
      
        setupTableView()
        //removing separators
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if UserDefaults.standard.string(forKey: "UserNameLogin") == nil || UserDefaults.standard.string(forKey: "UserNameLogin") == ""{
            alert.show(animated: true)
        }
    }

    
    //MARK:- UITableView
    
    fileprivate func setupTableView(){
        //register tables view
        let nib = UINib(nibName: "ChatListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatListCell
        
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
        
        cell.imageChat.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return cell
    }
    

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        
        if UserDefaults.standard.string(forKey: "UserNameLogin") != nil || UserDefaults.standard.string(forKey: "UserNameLogin") != ""{
            let chatViewController = ChatViewController()
            chatViewController.info = podcasts[indexPath.row]
            navigationController?.pushViewController(chatViewController, animated: true)
        }else{
            alert.show(animated: true)
        }
        
        
        
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
            UserDefaults.standard.deleteFeedback(podcast: selectedPodcast)
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "אין עדיין משוב"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.podcasts.count > 0 ? 0 : 250
    }


//MARK: - IBM login
func onAuthorizationCanceled() {
    
}

func onAuthorizationFailure(error: AuthorizationError) {
    print(error)
}

func onAuthorizationSuccess(accessToken: AccessToken?, identityToken: IdentityToken?, refreshToken: RefreshToken?, response: Response?) {
    
    //        print("Name",  identityToken?.name)
    //        print("userID " , identityToken?.subject)
    //        print("isAnonymous!!!!!! ", accessToken?.isAnonymous)
    
    UserDefaults.standard.set(accessToken?.isAnonymous, forKey: "myIsAnonymous")
    UserDefaults.standard.set(identityToken?.name, forKey: "myName")
    UserDefaults.standard.set(identityToken?.subject, forKey: "myUserID")
    // print("myUserID", identityToken?.subject)
     }


}

