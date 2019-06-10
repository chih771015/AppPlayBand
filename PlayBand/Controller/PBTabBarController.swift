//
//  PBTabBarController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/3.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

private enum Tab {

    case chat

    case booking

    case message

    case profile

    func controller() -> UIViewController {

        var controller: UIViewController

        switch self {

        case .chat: controller = UIStoryboard.chat.instantiateInitialViewController()!

        case .booking: controller = UIStoryboard.booking.instantiateInitialViewController()!

        case .message: controller = BaseNavigationViewController(rootViewController: MessageViewController())
            
        case .profile: controller = UIStoryboard.profile.instantiateInitialViewController()!

        }

        controller.tabBarItem = tabBarItem()

        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)

        return controller
    }

    func tabBarItem() -> UITabBarItem {

        switch self {

        case .chat:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.mail),
                selectedImage: UIImage.asset(.mail)
            )

        case .message:
   
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.calendar),
                selectedImage: UIImage.asset(.calendar)
            )

        case .booking:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.shopIcon),
                selectedImage: UIImage.asset(.shopIcon)
            )

        case .profile:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.user),
                selectedImage: UIImage.asset(.user)
            )
        }
    }
}

class PBTabBarController: UITabBarController, UITabBarControllerDelegate {

    private let tabs: [Tab] = [ .booking, .chat, .message, .profile]

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = tabs.map({ $0.controller() })

        delegate = self
        tabBar.tintColor = UIColor.playBandColorEnd
    }
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController == self.viewControllers?[0] {
            
            return true
        }
        
        guard FirebaseManager.shared.user().currentUser != nil else {
            
            self.addAlert(title: "尚未登入無法使用", message: "要去登入頁面登入嗎", actionTitle: "去登入", cancelTitle: "取消") { (_) in
                UIViewController.returnLoginPage()
            }
            
            return false
        }
        
        return true
    }
}
