//
//  MessageImageTableViewCell.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/26.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class MessageImageTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(url: String?) {
        if let url = url {
            photoImageView.lv_setImageWithURL(url: url)
        } else {
            return
        }
        
    }
}
