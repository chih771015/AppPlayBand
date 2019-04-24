//
//  CALayer+Extension.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/23.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

extension CALayer {
    
    static func getPBGradientLayer (bounds: CGRect) -> CAGradientLayer {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        let startColor = UIColor.playBandColorEnd
        let endColor = UIColor.playBandColorLightGreen
        gradientLayer.colors = [startColor?.cgColor, endColor?.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        return gradientLayer
    }
}
