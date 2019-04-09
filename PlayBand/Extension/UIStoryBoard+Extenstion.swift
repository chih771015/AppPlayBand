//
//  UIStoryBoard+Extenstion.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/3.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

private struct StoryboardCategory {

    static let main = "Main"

    static let news = "News"

    static let booking = "Booking"

    static let message = "Message"

    static let profile = "Profile"

    static let photo = "Photo"

}

extension UIStoryboard {

    static var main: UIStoryboard { return pbStoryboard(name: StoryboardCategory.main) }

    static var news: UIStoryboard { return pbStoryboard(name: StoryboardCategory.news) }

    static var booking: UIStoryboard { return pbStoryboard(name: StoryboardCategory.booking) }

    static var message: UIStoryboard { return pbStoryboard(name: StoryboardCategory.message) }

    static var profile: UIStoryboard { return pbStoryboard(name: StoryboardCategory.profile) }

    static var photo: UIStoryboard { return pbStoryboard(name: StoryboardCategory.photo)}

    private static func pbStoryboard(name: String) -> UIStoryboard {

        return UIStoryboard(name: name, bundle: nil)
    }
}
