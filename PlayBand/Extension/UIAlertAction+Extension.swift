//
//  UIAlertAction+Extension.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/3.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

extension UIAlertAction {
    
    func setupActionColor(color: UIColor? = UIColor.playBandColorEnd) {
        
        setValue(color, forKey: "titleTextColor")
    }
}
