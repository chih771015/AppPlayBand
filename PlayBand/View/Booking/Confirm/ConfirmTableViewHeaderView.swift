//
//  ConfirmTableViewHeaderView.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/9.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class ConfirmTableViewHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var backgroundModelView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupHeadView(storePhoto: String, storeName: String) {
        
        self.titleImage.lv_setImageWithURL(url: storePhoto)
        self.titleLabel.setupTextInPB(text: storeName)
    }
}
