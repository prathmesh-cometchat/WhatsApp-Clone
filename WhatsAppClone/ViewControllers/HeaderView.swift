//
//  HeaderView.swift
//  WhatsAppClone
//
//  Created by Admin on 08/02/24.
//

import UIKit

class HeaderView: UIView {
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let statusDot : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    let typingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Offline"
        label.textColor = UIColor.systemBlue
        return label
    }()
    
    public let callButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "phone"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public let videoCallButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "video"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public let infoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public let backButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           setupViews()
       }
    
    func setupViews(){
        profileImageView.addSubview(statusDot)
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(typingLabel)
        addSubview(callButton)
        addSubview(videoCallButton)
        addSubview(infoButton)
        addSubview(backButton)
        
        NSLayoutConstraint.activate([
    
            backButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            backButton.widthAnchor.constraint(equalToConstant: 10),
                   
            profileImageView.topAnchor.constraint(equalTo: topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 10),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            
            statusDot.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -2),
            statusDot.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor,constant: -2),
            statusDot.heightAnchor.constraint(equalToConstant: 10),
            statusDot.widthAnchor.constraint(equalToConstant: 10),
                   
            nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor,constant: -7),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: videoCallButton.leadingAnchor, constant: -10),
            nameLabel.widthAnchor.constraint(equalToConstant: 200),
            
            typingLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor,constant: 12),
            typingLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            typingLabel.trailingAnchor.constraint(equalTo: videoCallButton.leadingAnchor, constant: -10),
            typingLabel.widthAnchor.constraint(equalToConstant: 200),
                   
            videoCallButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            videoCallButton.widthAnchor.constraint(equalToConstant: 30),
            videoCallButton.heightAnchor.constraint(equalToConstant: 30),
            videoCallButton.trailingAnchor.constraint(equalTo: callButton.leadingAnchor, constant: -8),
            
            callButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            callButton.widthAnchor.constraint(equalToConstant: 30),
            callButton.heightAnchor.constraint(equalToConstant: 30),
            callButton.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor, constant: -8),
                   
            infoButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            infoButton.widthAnchor.constraint(equalToConstant: 30),
            infoButton.heightAnchor.constraint(equalToConstant: 30),
            infoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }

}
