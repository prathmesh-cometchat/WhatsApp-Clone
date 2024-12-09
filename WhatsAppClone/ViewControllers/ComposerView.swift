//
//  ComposerView.swift
//  WhatsAppClone
//
//  Created by Admin on 14/02/24.
//

import UIKit

class ComposerView: UIView {

    private let textField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type message here..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .gray.withAlphaComponent(0.1)
        return textField
    }()
    
    private let sendButton : UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
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
       
    }
    @objc func sendButtonTapped() {
        print("sendButtonTapped")
    }

}
