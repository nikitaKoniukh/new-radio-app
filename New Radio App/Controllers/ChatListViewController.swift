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

class ChatListViewController: UITableViewController, AuthorizationDelegate {
    
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
        print("myUserID", identityToken?.subject)
        
    }
    
    
    let cellId = "cellId"
    let cell = UITableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("IIIIDDDD", UserDefaults.standard.string(forKey: "myUserID") ?? "")
        if UserDefaults.standard.string(forKey: "myUserID") == nil{
            AppID.sharedInstance.signinAnonymously(authorizationDelegate: self)
            //AppID.sharedInstance.loginWidget?.launch(delegate: self)
        }
        
        
        setupTableView()
        //removing separators
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
       

    }
    
    
    //MARK:- UITableView
    
    fileprivate func setupTableView(){
        //register tables view
        let nib = UINib(nibName: "ChatListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatListCell
        
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
       //let cell = messageArray[indexPath.row]
        let chatViewController = ChatViewController()
        
        navigationController?.pushViewController(chatViewController, animated: true)
        
//        let targetNavigationController = UINavigationController(rootViewController: chatViewController)
//        
//        self.present(targetNavigationController, animated: true, completion: nil)
    }
    
}
