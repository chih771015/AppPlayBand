//
//  ProfileInformationTableViewCell.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/3.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class ProfileInformationTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var modelView: UIView!
    
    @IBOutlet weak var titleImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func settingProfilePage(title: String, data: String, image: UIImage? = nil) {

        self.titleLabel.setupTextInPB(text: title)
        self.dataLabel.setupTextInPB(text: data)
        self.titleImageView?.image = image
        //        self.dataLabel.setTextSpacingBy(value: 1.5)
    }
}
