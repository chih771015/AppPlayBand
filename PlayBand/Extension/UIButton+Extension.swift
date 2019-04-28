//
//  UIButton+Extension.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/23.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setupButtonModelPlayBand() {
        
        self.layoutIfNeeded()
        let gradientLayer = CALayer.getPBGradientLayer(bounds: self.bounds)
        self.layer.insertSublayer(gradientLayer, below: self.imageView?.layer)
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 19
        self.clipsToBounds = true
    }
}
