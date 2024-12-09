//
//  BubbleTableViewCell.swift
//  
//
//  Created by Admin on 08/02/24.
//

import UIKit

class BubbleTableViewCell: UITableViewCell {
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let timeStampLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
    }
    
    override func prepareForReuse() {
        bubbleView.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
    func configure(with message: String,with time : TimeInterval, isSentByCurrentUser: Bool) {
        
        addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        bubbleView.addSubview(timeStampLabel)
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            bubbleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
//            bubbleView.heightAnchor.constraint(lessThanOrEqualToConstant: 250),
//            bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
            //Commented the above line for getting the length of the messageLabel as the timeStamplabel
            bubbleView.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 6),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -8),
            messageLabel.bottomAnchor.constraint(equalTo: timeStampLabel.topAnchor, constant: -6),
            
            timeStampLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 3),
            timeStampLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -3),
//            timeStampLabel.widthAnchor.constraint(equalToConstant: 70),
//            timeStampLabel.widthAnchor.constraint(equalToConstant: 100),
            timeStampLabel.heightAnchor.constraint(equalToConstant: 10),
            timeStampLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor,constant: -6)
            
        ])
        
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let dateString = dateFormatter.string(from: date)
        timeStampLabel.text = dateString
        
            messageLabel.text = message
            if isSentByCurrentUser {
                bubbleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
            } else {
                bubbleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true

            }
        }
    
    private func setupViews() {
            // Configure bubble view
            bubbleView.translatesAutoresizingMaskIntoConstraints = false
            bubbleView.layer.cornerRadius = 10
            addSubview(bubbleView)
            
            // Configure message label
//            messageLabel.numberOfLines = 0
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            bubbleView.addSubview(messageLabel)
            
            // Add constraints
            NSLayoutConstraint.activate([
                bubbleView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
                bubbleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
                bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 250), // Max width of bubble
                messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 8),
                messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -8),
                messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
                messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8)
            ])
        }
        
        func configure2(with message: String, isOutgoing: Bool) {
            messageLabel.text = message
            if isOutgoing {
                bubbleView.backgroundColor = UIColor.blue.withAlphaComponent(0.6) // Outgoing message color
                messageLabel.textColor = .white
                bubbleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
                bubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 100).isActive = true
            } else {
                bubbleView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6) // Incoming message color
                messageLabel.textColor = .black
                bubbleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
                bubbleView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -100).isActive = true
            }
        }

}

