//
//  CallScreenViewController.swift
//  WhatsAppClone
//
//  Created by Admin on 23/02/24.
//

import UIKit
import CometChatSDK
import CometChatCallsSDK

class OutgoingCallScreenController: UIViewController {
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    private let callingLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "Calling"
        return label
    }()
    private let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 110
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        return imageView
    }()
    private let cancelButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.backgroundColor = UIColor.red
        button.clipsToBounds = true
        button.tintColor = .white
        button.layer.cornerRadius = 28
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let cancelLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Cancel"
        return label
    }()
    
    let conversation : Conversation
    
    init(conversation: Conversation) {
        self.conversation = conversation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        SetupUI()
        
        let user = conversation.conversationWith as? User
        nameLabel.text = user?.name
        let avatarUrl = URL(string: user?.avatar ?? "")
        DispatchQueue.global().async {
            if let imageData = try? Data(contentsOf: avatarUrl!),
               let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            }
        }
    }
    private func SetupUI(){
        view.addSubview(nameLabel)
        view.addSubview(callingLabel)
        view.addSubview(profileImageView)
        view.addSubview(cancelButton)
        view.addSubview(cancelLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 23),
            nameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            
            callingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            callingLabel.heightAnchor.constraint(equalToConstant: 16),
            callingLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            callingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 3),
            
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 220),
            profileImageView.widthAnchor.constraint(equalToConstant: 220),
            profileImageView.topAnchor.constraint(equalTo: callingLabel.bottomAnchor,constant: 200),
            
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 56),
            cancelButton.widthAnchor.constraint(equalToConstant: 56),
            cancelButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,constant: 130),
            
            cancelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelLabel.heightAnchor.constraint(equalToConstant: 15),
            cancelLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            cancelLabel.topAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            
            
        ])
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true)
    }

}
