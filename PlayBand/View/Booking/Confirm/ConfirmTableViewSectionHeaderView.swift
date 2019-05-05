//
//  ConfirmTableViewSectionHeaderView.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/9.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class ConfirmTableViewSectionHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(date: String, time: String, room: String) {
        
        self.dateLabel.setupTextInPB(text: date)
        self.timeLabel.setupTextInPB(text: time)
        self.roomNameLabel.setupTextInPB(text: room)
    }
    func deleteRowSetup(time: String) {
        
        self.timeLabel.setupTextInPB(text: time)
    }
}
