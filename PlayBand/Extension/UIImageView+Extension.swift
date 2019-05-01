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
            
            self.kf.setImage(with: interNetURL, placeholder: UIImage.asset(.user))
        } else {
            // swiftlint: disable line_length
           self.image = UIImage(contentsOfFile: "file:///Users/chiangchihhsuan/Library/Developer/CoreSimulator/Devices/83B45573-77C0-46C0-B881-01F21A03D81B/data/Containers/Data/Application/EF1FFC63-48A5-450A-8B05-28AABE7CB3F2/tmp/B9EA4873-9A16-4C00-A76D-13EF8BF5035C") // swiftlint:disable:this line_length
            // swiftlint: enable line_length
        }
    }
}
