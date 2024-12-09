//
//  TabBarController.swift
//  WhatsAppClone
//
//  Created by Admin on 06/02/24.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        
        let vc1 = UpdatesViewController()
        vc1.title = "Updates"
        vc1.tabBarItem.image = UIImage(systemName: "ellipsis.message")
        let vc2 =  CallsViewController()
        vc2.title = "Calls"
        vc2.tabBarItem.image = UIImage(systemName: "phone")
        let vc3 = CommunitiesViewController()
        vc3.title = "Communities"
        vc3.tabBarItem.image = UIImage(systemName: "person.3")
        let vc4 = ChatsViewController()
        vc4.title = "Chats"
        vc4.tabBarItem.image = UIImage(systemName: "bubble.left.and.text.bubble.right")
        let vc5 = SettingsViewController()
        vc5.title = "Settings"
        vc5.tabBarItem.image = UIImage(systemName: "gear")
        self.viewControllers = [vc1,vc2,vc3,vc4,vc5]
        self.selectedIndex = 3
        tabBar.isUserInteractionEnabled = false
    }
}

//MARK: - Tab View Controllers

class UpdatesViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        label.text = "Updates"
        label.center = view.center
        view.addSubview(label)
    }
}

class CallsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        label.text = "Calls"
        label.center = view.center
        view.addSubview(label)
    }
}

class CommunitiesViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
        label.text = "Communities"
        label.center = view.center
        view.addSubview(label)
    }
}

class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        label.text = "Settings"
        label.center = view.center
        view.addSubview(label)
    }
}
