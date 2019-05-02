//
//  CALayer+Extension.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/23.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

extension CALayer {
    
    static func getPBGradientLayer (bounds: CGRect, cornerRadius: CGFloat = 0) -> CAGradientLayer {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        guard let startColor = UIColor.playBandColorEnd else {return gradientLayer}
        guard let endColor = UIColor.playBandColorLightGreen else {return gradientLayer}
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = cornerRadius
        return gradientLayer
    }
}
