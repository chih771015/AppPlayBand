//
//  EditTableHeaderFooterView.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/1.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class EditTableHeaderFooterView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupHeader(title: String, description: String = "") {
        
        self.titleLabel.text = title
        self.descriptionLabel.text = description
    }
}
