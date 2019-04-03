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

}

extension UIStoryboard {
    
    static var main: UIStoryboard { return stStoryboard(name: StoryboardCategory.main) }
    
    static var news: UIStoryboard { return stStoryboard(name: StoryboardCategory.news) }
    
    static var booking: UIStoryboard { return stStoryboard(name: StoryboardCategory.booking) }
    
    static var message: UIStoryboard { return stStoryboard(name: StoryboardCategory.message) }
    
    static var profile: UIStoryboard { return stStoryboard(name: StoryboardCategory.profile) }

    private static func stStoryboard(name: String) -> UIStoryboard {
        
        return UIStoryboard(name: name, bundle: nil)
    }
}
