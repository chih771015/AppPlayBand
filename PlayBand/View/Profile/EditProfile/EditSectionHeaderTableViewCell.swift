//
//  EditSectionHeaderTableViewCell.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/26.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class EditSectionHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(title: String, description: String = "") {
        
        self.titleLabel.text = title
        self.descriptionLabel.text = description
    }
}
