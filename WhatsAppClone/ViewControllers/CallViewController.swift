//
//  CallViewController.swift
//  WhatsAppClone
//
//  Created by Admin on 26/02/24.
//

import UIKit
import CometChatSDK

class CallViewController: UIViewController {
    
    let receivedUser : User
    
    init(receivedUser : User){
        self.receivedUser = receivedUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let callView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        return view
    }()

    
    private let picImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "house.fill")
        return imageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupView()
    }
    func setupView() {
        view.addSubview(callView)
        callView.addSubview(picImageView)
        
        let avatarUrl = URL(string: receivedUser.avatar ?? "")
        DispatchQueue.global().async {
            if let imageData = try? Data(contentsOf: avatarUrl!),
               let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.picImageView.image = image
                }
            }
        }
        
        NSLayoutConstraint.activate([
            callView.topAnchor.constraint(equalTo: view.topAnchor,constant: 5),
            callView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            callView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            callView.heightAnchor.constraint(equalToConstant: 510),
            
            picImageView.centerXAnchor.constraint(equalTo: callView.centerXAnchor),
            picImageView.centerYAnchor.constraint(equalTo: callView.centerYAnchor),
            picImageView.widthAnchor.constraint(equalToConstant: 160),
            picImageView.heightAnchor.constraint(equalToConstant: 160),
            
        ])
    }

}
