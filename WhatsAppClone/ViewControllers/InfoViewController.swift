//
//  InfoViewController.swift
//  WhatsAppClone
//
//  Created by Admin on 06/04/24.
//

import UIKit
import CometChatSDK

class InfoViewController: UIViewController {
    
    let conversation : Conversation
    
    init(conversation : Conversation){
        self.conversation = conversation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.text = "Details"
        return label
    }()
    
    let blockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Block User"
        label.textColor = .red
        return label
    }()
    
    let infoView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor  = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    public let cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.titleLabel?.textColor = .red
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    

    func setupUI(){
        view.addSubview(cancelButton)
        view.addSubview(infoView)
        view.addSubview(detailLabel)
        view.addSubview(blockLabel)
        infoView.addSubview(profileImageView)
        infoView.addSubview(nameLabel)
        let user = conversation.conversationWith as? User
        if let user = user{
            let avatarUrl = URL(string: user.avatar ?? "")
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: avatarUrl!),
                   let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                    }
                }
            }
            nameLabel.text = user.name
        }
        
        NSLayoutConstraint.activate([
            
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor,constant: 10),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            
            detailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            
            infoView.topAnchor.constraint(equalTo: detailLabel.bottomAnchor,constant: 30),
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            infoView.heightAnchor.constraint(equalToConstant: 100),
            
            blockLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            blockLabel.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 40),
            
            profileImageView.topAnchor.constraint(equalTo: infoView.topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 10),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
                   
            nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor,constant: -2),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalToConstant: 200),
        ])
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    @objc func cancelButtonTapped(){
        dismiss(animated: true)
    }

}
