//
//  SettingTableViewCell.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/6.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var titleImage: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var switchObject: UISwitch!

    @IBOutlet weak var backImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupWithSwitch(title: String, image: String) {

        titleImage.image = UIImage(named: image)
        titleLabel.setupTextInPB(text: title)
        switchObject.isHidden = false
        backImage.isHidden =  true
    }

    func setupWithoutSwitch(title: String, image: String) {

        titleImage.image = UIImage(named: image)
        titleLabel.setupTextInPB(text: title)
        backImage.isHidden =  false
        switchObject.isHidden = true
    }
    
    func setupWithBlackList(title: String, image: String) {
        setupWithoutSwitch(title: title, image: image)
        backImage.isHidden = true
    }
}
