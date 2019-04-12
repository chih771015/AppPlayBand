//
//  MessageTableViewCell.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/11.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleView: UIView! {
        didSet {
            
            titleView.layer.cornerRadius = 10
            titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            titleView.layer.shadowOffset = CGSize(width: 5, height: 3.5)
            titleView.layer.shadowOpacity = 0.2
            titleView.layer.shadowRadius = 5
            titleView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 0.7).cgColor
        }
    }
    
    @IBOutlet weak var descriptionView: UIView! {
        didSet {
            
            descriptionView.layer.cornerRadius = 10
            descriptionView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            descriptionView.layer.shadowOffset = CGSize(width: 2, height: 3.5)
            descriptionView.layer.shadowOpacity = 0.2
            descriptionView.layer.shadowRadius = 5
            descriptionView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 0.7).cgColor
        }
    }
    
    @IBOutlet weak var storeImage: UIImageView! {
        didSet {
            
            storeImage.layer.cornerRadius = 10
            storeImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            storeImage.layer.shadowOffset = CGSize(width: 5, height: 3.5)
            storeImage.layer.shadowOpacity = 0.2
            storeImage.layer.shadowRadius = 5
            storeImage.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 0.7).cgColor
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
}
