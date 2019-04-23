//
//  UIView+Extension.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/3.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {

    @IBInspectable var lvBorderColor: UIColor? {
        get {

            guard let borderColor = layer.borderColor else {

                return nil
            }

            return UIColor(cgColor: borderColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable var lvBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var lvCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    func addGradientColor() {
        
        let gradientLayer = CAGradientLayer()
        //        colorView.layoutIfNeeded()
        gradientLayer.frame = self.bounds
        let startColor = UIColor.playBandColorGreen
        let endColor = UIColor.playBandColorLightGreen
        gradientLayer.colors = [startColor?.cgColor, endColor?.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.layer.addSublayer(gradientLayer)
    }
    
    func addGradientColorLandscape() {
        
        let gradientLayer = CAGradientLayer()
        //        colorView.layoutIfNeeded()
        gradientLayer.frame = self.bounds
        let startColor = UIColor.playBandColorEnd
        let endColor = UIColor.playBandColorLightGreen
        gradientLayer.colors = [startColor?.cgColor, endColor?.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        self.layer.addSublayer(gradientLayer)
    }
    func addShadow() {
        
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowColor = UIColor.lightGray.cgColor
    }
}
