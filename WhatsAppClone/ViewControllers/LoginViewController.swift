//
//  LoginViewController.swift
//  WhatsAppClone
//
//  Created by Admin on 24/05/24.
//

import UIKit
import CometChatSDK

class LoginViewController: UIViewController {
    
    private let logoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Image.png")
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sample App"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .gray
        return label
    }()
    
    private let textfield : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter UID here"
        textField.textAlignment = .center
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private let logInButton : UIButton =  {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 20
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let sampleUIDButton : UIButton =  {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sample UID's", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(textfield)
        view.addSubview(titleLabel)
        view.addSubview(logInButton)
        view.addSubview(sampleUIDButton)
        view.addSubview(logoImageView)
        logInButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        sampleUIDButton.addTarget(self, action: #selector(sampleUIDButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            textfield.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            textfield.heightAnchor.constraint(equalToConstant: 60),
            textfield.widthAnchor.constraint(equalToConstant: 350),
            textfield.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            logInButton.topAnchor.constraint(equalTo: textfield.bottomAnchor,constant: 50),
            logInButton.heightAnchor.constraint(equalToConstant: 40),
            logInButton.widthAnchor.constraint(equalToConstant: 150),
            logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 90),
            
            sampleUIDButton.topAnchor.constraint(equalTo: textfield.bottomAnchor,constant: 50),
            sampleUIDButton.heightAnchor.constraint(equalToConstant: 40),
            sampleUIDButton.widthAnchor.constraint(equalToConstant: 150),
            sampleUIDButton.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: -90)
            
        ])
    }
    
    @objc func loginButtonTapped() {
        if textfield.text == "" {
            getAlert(message: "UID Cannot be blank")
            return
        }

        if let uid = textfield.text {
            if ChatsHelper.shared.LoginUserMethod(uid: uid){
                (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate as SceneDelegate).changeRootViewController(vc: UINavigationController(rootViewController: TabBarController()))
            }else{
                getAlert(message: "User is not present with given UID")
            }
        }
    }
    @objc func sampleUIDButtonTapped() {
        let sampleUIDViewController = SampleUIDViewController()
        present(sampleUIDViewController, animated: true)
    }
    
    

    private func getAlert(message : String){
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            }))
            self.present(alert, animated: true)
    }
        
    private func createTabBarController(){
            let tabBarVC = TabBarController()
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc: tabBarVC)
    }

}
