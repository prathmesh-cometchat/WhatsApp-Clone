//
//  MenuOptionsViewController.swift
//  WhatsAppClone
//
//  Created by Admin on 06/04/24.
//

import UIKit
import CometChatSDK

class MenuOptionsViewController: UIViewController,UISheetPresentationControllerDelegate {
    
    var menuArray : [(String,String)] = [("Take a photo","camera"),("Photo & Video Library","photo.on.rectangle.angled"),("Document","doc.plaintext"),("Collaborative Whiteboard","rectangle.inset.filled.badge.record"),("Create a Poll","list.dash.header.rectangle")]

    var backgroundView = UIView()

    var text: String?
    
    let headingLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.text = "Add to Chat"
        return label
    }()
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray.withAlphaComponent(0.8)
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 10
        view.addSubview(tableView)
        view.addSubview(headingLabel)
        
        
        sheetPresentationController.delegate = self
        sheetPresentationController.detents = [ .custom(resolver: { context in
            return 400
        })]
        sheetPresentationController.selectedDetentIdentifier = .medium
        sheetPresentationController.prefersGrabberVisible = false
        
        
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: 20),
            headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            tableView.topAnchor.constraint(equalTo: view.topAnchor,constant: 60),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -40)
        ])
    }

}
extension MenuOptionsViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        let menu = menuArray[indexPath.row]
        cell.answerLabel.text = menu.0
        cell.menuImageView.image = UIImage(systemName: menu.1)
        cell.buildUI()
        return cell
    }
    
}
