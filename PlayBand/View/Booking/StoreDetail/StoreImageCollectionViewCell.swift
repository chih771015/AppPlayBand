//
//  StoreImageCollectionViewCell.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/23.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class StoreImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var storeImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupImage(url: String) {
        
        storeImage.lv_setImageWithURL(url: url)
    }
    
    func setupImageInImage(image: UIImage) {
        
        storeImage.image = image
    }
}
