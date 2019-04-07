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



    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        podcasts = UserDefaults.standard.saveFeedback()
        tableView.reloadData()
        UIApplication.mainTabController()?.viewControllers?[2].tabBarItem.badgeValue = nil
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if UserDefaults.standard.string(forKey: "UserNameLogin") == nil || UserDefaults.standard.string(forKey: "UserNameLogin") == ""{
            alerDialogLogin()
        }
       // print("IIIIDDDD", UserDefaults.standard.string(forKey: "myUserID") ?? "")
        if UserDefaults.standard.string(forKey: "myUserID") == nil{
            alerDialogLogin()
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
            alerDialogLogin()
        }
    }

    
    func alerDialogLogin(){
        let alert = UIAlertController(title: "ספר לנו, מה שמך", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "בטל", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "הכנס את שמך כאן"
        })
        
        alert.addAction(UIAlertAction(title: "סבבה", style: .default, handler: { action in
            
            if let name = alert.textFields?.first?.text {
                print("Your name: \(name)")
            UserDefaults.standard.set(name, forKey: "UserNameLogin")
            }
        }))
        
        self.present(alert, animated: true)
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
        
        cell.chatNameLabel.text = podcasts[indexPath.row].name
        
        cell.viewChatCel.layer.borderWidth = 0.5
        cell.viewChatCel.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        // Make it card-like
        cell.viewChatCel.layer.cornerRadius = 10
        cell.viewChatCel.layer.shadowOpacity = 1
        cell.viewChatCel.layer.shadowRadius = 5
        cell.viewChatCel.layer.shadowColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor
        cell.viewChatCel.layer.shadowOffset = CGSize(width: 3, height: 3)

      
        
        return cell
    }
    

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        
        if UserDefaults.standard.string(forKey: "UserNameLogin") != nil || UserDefaults.standard.string(forKey: "UserNameLogin") != ""{
            let chatViewController = ChatViewController()
            chatViewController.info = podcasts[indexPath.row]
            navigationController?.pushViewController(chatViewController, animated: true)
        }else{
            alerDialogLogin()
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
