//
//  UIImageView+Extension.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/16.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func lv_setImageWithURL(url: String) {
        
        guard let url = URL(string: url) else {return}
     //   self.kf.setImage(with: url)
        self.kf.setImage(with: url, placeholder: UIImage.asset(.user))
    }
}
