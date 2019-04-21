//
//  MessageConfirmPageTableViewCell.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/12.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class MessageConfirmPageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    weak var delgate: MessageConfirmCellDelgate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellDefault(title: String?, description: String?) {
        
        button.isHidden = true
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    func setupCellFirst(title: String?, description: String?, messageConfirmDelgate: MessageConfirmCellDelgate) {
        
        button.isHidden = false
        titleLabel.text = title
        descriptionLabel.text = description
        delgate = messageConfirmDelgate
    }
    
    @IBAction func buttonAction() {
        guard let title = titleLabel.text else {return}
        delgate?.buttonAction(title: title)
    }
    
}

protocol MessageConfirmCellDelgate: class {
    
    func buttonAction(title: String)
}
