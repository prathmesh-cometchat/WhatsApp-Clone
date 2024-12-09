//
//  IncomingScreenViewController.swift
//  WhatsAppClone
//
//  Created by Admin on 23/02/24.
//

import UIKit
import CometChatSDK
import CometChatCallsSDK

class IncomingScreenViewController: UIViewController {
    var incomingCall = CometChat.currentCall

    private let nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    private let callingLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "Incoming audio call"
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
    private let declineButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.backgroundColor = UIColor.red
        button.clipsToBounds = true
        button.layer.cornerRadius = 28
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let acceptButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "phone"), for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.clipsToBounds = true
        button.layer.cornerRadius = 28
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let declineLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Decline"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    private let acceptLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Accept"
        label.font = UIFont.systemFont(ofSize: 14)
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
        view.addSubview(declineButton)
        view.addSubview(declineLabel)
        view.addSubview(acceptButton)
        view.addSubview(acceptLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 23),
            nameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            
            callingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            callingLabel.heightAnchor.constraint(equalToConstant: 16),
            callingLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
            callingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 3),
            
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 220),
            profileImageView.widthAnchor.constraint(equalToConstant: 220),
            profileImageView.topAnchor.constraint(equalTo: callingLabel.bottomAnchor,constant: 200),
            
            declineButton.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: -100),
            declineButton.heightAnchor.constraint(equalToConstant: 56),
            declineButton.widthAnchor.constraint(equalToConstant: 56),
            declineButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,constant: 130),
            
            declineLabel.centerXAnchor.constraint(equalTo: declineButton.centerXAnchor),
            declineLabel.heightAnchor.constraint(equalToConstant: 15),
            declineLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            declineLabel.topAnchor.constraint(equalTo: declineButton.bottomAnchor),
            
            acceptButton.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 100),
            acceptButton.heightAnchor.constraint(equalToConstant: 56),
            acceptButton.widthAnchor.constraint(equalToConstant: 56),
            acceptButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,constant: 130),
            
            acceptLabel.centerXAnchor.constraint(equalTo: acceptButton.centerXAnchor),
            acceptLabel.heightAnchor.constraint(equalToConstant: 15),
            acceptLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            acceptLabel.topAnchor.constraint(equalTo: acceptButton.bottomAnchor),
            
            
        ])
        
        declineButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
    }
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true)
        let status = CometChatSDK.CometChat.callStatus.cancelled;

        CometChat.rejectCall(sessionID: (incomingCall?.sessionID)!, status: status, onSuccess: { (rejeceted_call) in
                            
          print("Call rejected successfully. " + rejeceted_call!.stringValue());
          
        }) { (error) in

          print("Call rejection failed with error:  " + error!.errorDescription);
        }
    }
    @objc func acceptButtonTapped(){ 
        let view = 
        CometChat.acceptCall(sessionID: incomingCall!.sessionID!, onSuccess: { (ongoing_call) in
          print("Accepted Call. " + ongoing_call!.stringValue());

        }) { (error) in

          print("Call accepting failed with error:  " + error!.errorDescription);
        }
    }

}

