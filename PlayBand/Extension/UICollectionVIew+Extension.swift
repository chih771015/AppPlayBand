//
//  UICollectionVIew+Extension.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/23.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func lv_reqisterCellWithNib(identifier: String, bundle: Bundle?) {
        
        let nib = UINib(nibName: identifier, bundle: bundle)
        
        register(nib, forCellWithReuseIdentifier: identifier)
    }
}
