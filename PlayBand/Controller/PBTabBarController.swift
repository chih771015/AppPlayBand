//
//  PBTabBarController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/3.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

private enum Tab {

    case news

    case booking

    case message

    case profile

    func controller() -> UIViewController {

        var controller: UIViewController

        switch self {

        case .news: controller = UIStoryboard.news.instantiateInitialViewController()!

        case .booking: controller = UIStoryboard.booking.instantiateInitialViewController()!

        case .message: controller = UIStoryboard.message.instantiateInitialViewController()!

        case .profile: controller = UIStoryboard.profile.instantiateInitialViewController()!

        }

        controller.tabBarItem = tabBarItem()

        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)

        return controller
    }

    func tabBarItem() -> UITabBarItem {

        switch self {

        case .news:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.newspaper),
                selectedImage: UIImage.asset(.newspaper)
            )

        case .booking:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.calendar),
                selectedImage: UIImage.asset(.calendar)
            )

        case .message:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.mail),
                selectedImage: UIImage.asset(.mail)
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

    private let tabs: [Tab] = [.news, .booking, .message, .profile]

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = tabs.map({ $0.controller() })

        delegate = self
        tabBar.tintColor = UIColor.playBandColorGreen
    }
    
}
