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
    @IBOutlet weak var modelView: UIView! {
        
        didSet {
            modelView.layer.shadowOffset = CGSize(width: 3, height: 3)
            modelView.layer.shadowOpacity = 0.5
 //           modelView.layer.shadowRadius = 500
            modelView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 0.3).cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func settingProfilePage(title: String, data: String) {

        self.titleLabel.text = title
        self.titleLabel.setTextSpacingBy(value: 1.5)
        self.dataLabel.text = data
        self.dataLabel.setTextSpacingBy(value: 1.5)
    }

}
