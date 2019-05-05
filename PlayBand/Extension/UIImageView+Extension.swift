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
        
        if let interNetURL = URL(string: url) {
            
            if let color = UIColor.playBandColorEnd {
                 self.tintColor = color
            }
            self.contentMode = .scaleAspectFit
            self.kf.setImage(with: interNetURL, placeholder: UIImage.asset(.loading)) { [weak self] (_) in
                self?.contentMode = .scaleAspectFill
            }
        } else {
            return
        }
    }
}
