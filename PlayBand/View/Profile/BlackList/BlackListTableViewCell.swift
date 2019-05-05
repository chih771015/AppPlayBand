//
//  BlackListTableViewCell.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/5.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class BlackListTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonAction: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(title: String, image: UIImage?, target: Any, action: Selector, tag: Int) {
        
        titleLabel.setupTextInPB(text: title)
        iconImageView.image = image
        buttonAction.addTarget(target, action: action, for: .touchUpInside)
        buttonAction.tag = tag
    }
    
}
