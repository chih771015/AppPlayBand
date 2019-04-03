//
//  UIImage+Extension.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/11.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

enum ImageAsset: String {
    
    case calendar
    case mail
    case newspaper
    case user
}

extension UIImage {
    
    static func asset(_ asset: ImageAsset) -> UIImage? {
        
        return UIImage(named: asset.rawValue)
    }
    
}
