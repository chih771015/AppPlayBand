//
//  EditTableViewCell.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/5.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class EditTableViewCell: UITableViewCell {

    
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupEditCell(placeholder: String) {
        
        textField.placeholder = placeholder
    }
    
}
