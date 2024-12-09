//
//  MenuTableViewCell.swift
//  WhatsAppClone
//
//  Created by Admin on 06/04/24.
//

//
//  AnswerTableViewCell.swift
//  iOSUIKitDemo
//
//  Created by Admin on 12/02/24.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    let menuImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "house")
        return imageView
    }()
    
    let answerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func buildUI() {
        contentView.addSubview(menuImageView)
        contentView.addSubview(answerLabel)
        NSLayoutConstraint.activate([
            menuImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            menuImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 30),
            menuImageView.heightAnchor.constraint(equalToConstant: 25),
            menuImageView.widthAnchor.constraint(equalToConstant: 25),
            
            answerLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            answerLabel.leadingAnchor.constraint(equalTo: menuImageView.trailingAnchor,constant: 20)
        ])
    }

}

