//
//  ViewController.swift
//  WhatsAppClone
//
//  Created by Admin on 06/02/24.
//

import UIKit
import CometChatSDK
import CometChatCallsSDK

class ChatsViewController: UIViewController , UISearchBarDelegate, UpdatingLastMessage {

    let tableView : UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    let activityIndicator : UIActivityIndicatorView = {
        let avIndicator = UIActivityIndicatorView()
        avIndicator.style = .large
        avIndicator.color = .gray
        return avIndicator
    }()
    var chat : Chat = Chat()
    
    private var searchController = UISearchController(searchResultsController: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        chat.conversationArray = []
        navigationController?.navigationBar.prefersLargeTitles = true
        tabBarController?.title = "Chats"
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "power.circle"), style: .plain, target: self, action: #selector(logoutButtonTapped))
        tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(editButtonTapped))
        setupSearchController()
        chat.fetchConversation { isSuccess in
            if isSuccess {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //MARK: - Function calls
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
    
        setupSearchController()
        
        
        view.backgroundColor = .gray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
                
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = true
        self.searchController.searchBar.placeholder = "Search"
        self.tabBarController?.navigationItem.searchController = searchController
        self.tabBarController?.definesPresentationContext = true
        self.tabBarController?.navigationItem.hidesSearchBarWhenScrolling = true
    }
    @objc func logoutButtonTapped(){
        CometChat.logout(onSuccess: { (response) in
          print("Logout successfully.")
        }) { (error) in
          print("logout failed with error: " + error.errorDescription);
        }
        (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate as SceneDelegate).changeRootViewController(vc: LoginViewController())
    }
    @objc func editButtonTapped(){
        print("Edit button Tapped")
        

    }
}
//MARK: - Search Bar Functions
extension ChatsViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    }

}
// MARK: - TableView Functions
extension ChatsViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.conversationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell

        let conversation = chat.conversationArray[indexPath.row]
        if let user = conversation.conversationWith as? User {
            
            if let avatarUrl = URL(string: user.avatar ?? ""){
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: avatarUrl),
                       let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            cell.profileImageView.image = image
                        }
                    }
                }
            }
            cell.nameLabel.text = user.name
        }
        //for group
        if let group = conversation.conversationWith as? Group {
            
            let avatarUrl = URL(string: group.icon ?? "house")
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: avatarUrl!),
                   let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        cell.profileImageView.image = image
                    }
                }
            }
            cell.nameLabel.text = group.name
        }
        
        
        let lastMessage = conversation.lastMessage as? TextMessage
        cell.messageLabel.text = lastMessage?.text
        let time = conversation.updatedAt
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let dateString = dateFormatter.string(from: date)
        cell.timeStampLabel.text = dateString
        if conversation.unreadMessageCount > 0 {
            cell.badgeLabel.text = String(conversation.unreadMessageCount)
        }else {
            cell.badgeLabel.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ConversationViewController(conversation: chat.conversationArray[indexPath.row])
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    func changeLastMessage() {
        chat.conversationArray = []
    }
    
}


