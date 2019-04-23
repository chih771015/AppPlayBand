//
//  UIColor+Extension.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/22.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

private enum PBColor: String {
    
    case colorGreen
    case endColor
    case lightGreen
    case lightMoreGreen
}

extension UIColor {
    
    static let playBandColorGreen = PBColor(.colorGreen)
    static let playBandColorEnd = PBColor(.endColor)
    static let playBandColorLightGreen = PBColor(.lightGreen)
    static let playBandColorLightMoreGreen = PBColor(.lightMoreGreen)
    
    private static func PBColor(_ color: PBColor) -> UIColor? {
        
        return UIColor(named: color.rawValue)
    }
}
