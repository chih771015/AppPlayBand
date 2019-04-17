//
//  StoreInformationTableViewCell.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/7.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class StoreInformationTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(name: String?, phone: String?, address: String?) {
        
        self.titleLabel.text = name
        self.phoneLabel.text = phone
        self.addressLabel.text = address
    }

}
