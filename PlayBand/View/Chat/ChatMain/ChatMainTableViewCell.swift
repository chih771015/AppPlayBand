//
//  ChatMainTableViewCell.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/6/6.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class ChatMainTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleIamge: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(title: String, description: String, imageURL: String?) {
        
        self.titleLabel.setupTextInPB(text: title)
        self.descriptionLabel.setupTextInPB(text: description)
        self.titleIamge.lv_setImageWithURL(url: imageURL ?? "")
    }
}
