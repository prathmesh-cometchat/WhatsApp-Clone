//
//  SampleUIDViewController.swift
//  WhatsAppClone
//
//  Created by Admin on 25/05/24.
//

import UIKit

class SampleUIDViewController: UIViewController ,UISheetPresentationControllerDelegate {
        
    let UIDArray: [(String, String)] = [("Superhero1","ironman_avatar.png"), ("Superhero2","captainamerica_avatar.png"), ("Superhero3","spiderman_avatar.png"), ("Superhero4","cyclops_avatar.png")]

        var backgroundView = UIView()
        let sendButton = UIButton()
        
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
            
            view.backgroundColor = .white
            tableView.register(UsersTableViewCell.self, forCellReuseIdentifier: "cell")
            tableView.delegate = self
            tableView.dataSource = self
            view.addSubview(tableView)
            
            
            sheetPresentationController.delegate = self
            sheetPresentationController.detents = [ .custom(resolver: { context in
                return 250
            })]
            sheetPresentationController.selectedDetentIdentifier = .medium
            sheetPresentationController.prefersGrabberVisible = false
            
            NSLayoutConstraint.activate([
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.topAnchor.constraint(equalTo: view.topAnchor,constant: 5),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -5)
            ])
        }
       
        

    }
    extension SampleUIDViewController : UITableViewDelegate,UITableViewDataSource {
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 70
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return UIDArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UsersTableViewCell
            let (name, image) = UIDArray[indexPath.row]
            cell.nameLabel.text = name
            cell.profileImageView.image = UIImage(named: image)
            return cell
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UsersTableViewCell
            let (name, image) = UIDArray[indexPath.row]
            ChatsHelper.shared.LoginUserMethod(uid: name)
            (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate as SceneDelegate).changeRootViewController(vc: UINavigationController(rootViewController: TabBarController()))
        }
        
    }

