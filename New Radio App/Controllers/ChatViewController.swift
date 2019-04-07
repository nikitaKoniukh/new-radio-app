//
//  ChatViewController.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 01/04/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit
import FirebaseDatabase


class ChatViewController: UITableViewController {

    let cellId = "messageCell"
    var ref: DatabaseReference?
    var handle: DatabaseHandle?
    var playerDetailsView = PlayerDetaislView()
    var allComments = [CommentModel]()
    var time = [String]()
    var chatId: String!
    var userNameLogin = UserDefaults.standard.string(forKey: "UserNameLogin")
    var userIdLogin = UserDefaults.standard.string(forKey: "myUserID")
    
  
    
    var info: Podcast!{
        didSet{
            chatId = info._id
        }
    }
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
  
        self.navigationController!.view.addSubview(messagesInputContainer)
        setupLayout()
        setupInputComponents()
        
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        getMessages { (messages) in
            self.allComments = messages
            self.tableView.reloadData()
        }
        
        setupTableView()
        
     
       
        
     
    }

    func createChatwithPodcastId(){

       // let refComments = ref!.child("chats")
       // let refChats = ref!.child(chatId)

        let refChat = ref!.childByAutoId()

        refChat.setValue(["message": ""])
        refChat.updateChildValues(["timestamp": ""])
        refChat.updateChildValues(["userID": ""])
        refChat.updateChildValues(["userName": ""])




        tableView.reloadData()
    }
    
    
    @objc func handleSend(){
        if !getTextMessage().isEmpty{
            let message = ["message" : getTextMessage(), "userID" : userIdLogin ?? "", "userName" : userNameLogin ?? "", "timestamp" : ServerValue.timestamp()] as [String : Any]
            ref?.childByAutoId().setValue(message)
            inputTextField.text = ""
        }
    }

        func getTextMessage() -> String{
            return inputTextField.text!
        }
    

    // MARK: - get messages
    func getMessages(completion:@escaping ([CommentModel])->()){
        ref = Database.database().reference().child("comments").child(chatId)
        
        ref?.observe(.value, with: { (snapshot) in
            if snapshot.childrenCount > 0{
                self.allComments.removeAll()
               // self.tableView.reloadData()
                 var allmessages = [CommentModel]()
                for comments in snapshot.children.allObjects as! [DataSnapshot]{
                    let commentObject = comments.value as? [String : AnyObject]
                    let message = commentObject?["message"]
                    let timestamp = commentObject?["timestamp"]
                    let userID = commentObject?["userID"]
                    let userName = commentObject?["userName"]
                    
                    
                    let comment = CommentModel(message: message as! NSString, timestamp: timestamp as! NSNumber, userID: userID as! NSString, userName: userName as! NSString)
                    
                    allmessages.append(comment)
                }
                
                for comment in allmessages{
                    let t = TimeInterval(exactly: comment.timestamp)!
                    self.time.append(self.getTime(timestamp: t))
                }
                completion(allmessages)
            }
        })
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
    
    
    //MARK: - ViewDidApear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
        let mainTabController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabController?.noPlayerDesplayed()
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        tabBarController?.tabBar.isHidden = false
        inputTextField.endEditing(true)
        
        let mainTabController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabController?.minimizePlayerDetails()
    }
    
    //MARK:- UITableView
    
    fileprivate func setupTableView(){
        //register tables view
        let nib = UINib(nibName: "MessageCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "messageCell")
        //removing separators
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allComments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        
        cell.textMessage.text = allComments[indexPath.row].message as String
        cell.nameMessage.text = allComments[indexPath.row].userName as String
        
        cell.dateMessage.text = time[indexPath.row]
        
        cell.selectionStyle = .none
        
        cell.messageViewCell.layer.borderWidth = 0.5
        cell.messageViewCell.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        // Make it card-like
        cell.messageViewCell.layer.cornerRadius = 5
        cell.messageViewCell.layer.shadowOpacity = 1
        cell.messageViewCell.layer.shadowRadius = 5
        cell.messageViewCell.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).cgColor
        cell.messageViewCell.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        inputTextField.endEditing(true )
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "שלח את המשוב הראשון שלך"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.allComments.count > 0 ? 0 : 250
    }
    
    //MARK: - textField & keyboard
    let messagesInputContainer: UIView = {
        let views = UIView()
        views.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        views.translatesAutoresizingMaskIntoConstraints = false
        return views
    }()
    
    var inputTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
   lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send"), for: .normal)
        button.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    
    var bottomConstraint: NSLayoutConstraint?
    
    private func setupLayout() {
        self.navigationController!.view.addSubview(messagesInputContainer)
        
        messagesInputContainer.centerXAnchor.constraint(equalTo: (navigationController?.view.centerXAnchor)!).isActive = true
        messagesInputContainer.widthAnchor.constraint(equalToConstant: (navigationController?.view.frame.width)!).isActive = true
        messagesInputContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bottomConstraint = NSLayoutConstraint(item: messagesInputContainer, attribute: .bottom, relatedBy: .equal, toItem: navigationController?.view, attribute: .bottom, multiplier: 1, constant: 0)
        navigationController?.view.addConstraint(bottomConstraint!)
    }
    
    func setupInputComponents(){
        let topBorderView = UIView()
        topBorderView.translatesAutoresizingMaskIntoConstraints = false
        topBorderView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        messagesInputContainer.addSubview(sendButton)
        messagesInputContainer.addSubview(inputTextField)
        messagesInputContainer.addSubview(topBorderView)
        
        
        inputTextField.leadingAnchor.constraint(equalTo: (navigationController?.view.leadingAnchor)!, constant: 8).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: (navigationController?.view.trailingAnchor)!, constant: -8).isActive = true
        
        inputTextField.widthAnchor.constraint(equalToConstant: (navigationController?.view.frame.width)! - 68).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        topBorderView.widthAnchor.constraint(equalToConstant: (navigationController?.view.frame.width)!).isActive = true
        topBorderView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        inputTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func handleKeyBoardNotification(notification: NSNotification ){
        
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            
            let isKeyBoardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            bottomConstraint?.constant = isKeyBoardShowing ? -keyboardFrame!.height : 0
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.navigationController?.view.layoutIfNeeded()
            }) { (complete) in
                if isKeyBoardShowing{
//                    let indexPath = NSIndexPath(item: self.allComments.count-1, section: 0)
//                    self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    
 

}
