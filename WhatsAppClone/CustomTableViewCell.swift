//
//  CustomTableViewCell.swift
//  WhatsAppClone
//
//  Created by Admin on 06/02/24.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
        let profileImageView : UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 28
            imageView.backgroundColor = .lightGray
            imageView.clipsToBounds = false
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
            return imageView
        }()
    
        let nameLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 20)
            return label
        }()
        
        let messageLabel : UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 13.5)
            label.numberOfLines = 2
            label.textColor = .gray
            return label
        }()
        
        let timeStampLabel : UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .gray
            return label
        }()
        let badgeLabel : UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 12)
            label.backgroundColor = .green
            label.layer.cornerRadius = 9
            label.textAlignment = .center
            label.text = "14"
            label.clipsToBounds = true
            return label
        }()
        let statusDot : UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .lightGray
            view.clipsToBounds = true
            view.layer.cornerRadius = 6
            return view
        }()
    
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupSubviews()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupSubviews()
        }
        
        private func setupSubviews() {
            profileImageView.addSubview(statusDot)
            contentView.addSubview(profileImageView)
            contentView.addSubview(nameLabel)
            contentView.addSubview(messageLabel)
            contentView.addSubview(timeStampLabel)
            contentView.addSubview(badgeLabel)
            
            NSLayoutConstraint.activate([
                nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15),
                nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -70),
                
                messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
                messageLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15),
                messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
                
                statusDot.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -3),
                statusDot.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor,constant: -3),
                statusDot.heightAnchor.constraint(equalToConstant: 12),
                statusDot.widthAnchor.constraint(equalToConstant: 12),
                
                profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
                profileImageView.widthAnchor.constraint(equalToConstant: 56),
                profileImageView.heightAnchor.constraint(equalToConstant: 56),
                profileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                
                timeStampLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                timeStampLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
                
                badgeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -15),
                badgeLabel.heightAnchor.constraint(equalToConstant: 18),
                badgeLabel.widthAnchor.constraint(equalToConstant: 24),
                badgeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor,constant: 5),
            ])
        }
    

}
