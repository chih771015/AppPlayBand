//
//  MessageOrderTableViewCell.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/24.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class MessageOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var rightImage: UIImageView!
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var hoursLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var titleImage: UIImageView!
    var caGradientLayer: CAGradientLayer?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(title: String, date: String, hours: Int, status: String, url: String?) {
        
        self.titleLabel.setupTextInPB(text: title)
        self.dateLabel.setupTextInPB(text: date)
        self.hoursLabel.setupTextInPB(text: "總計 \(hours) 小時")
        self.statusLabel.setupTextInPB(text: status)
        self.statusLabel.textAlignment = .left
        
        if let url = url {
            self.titleImage.lv_setImageWithURL(url: url)
        } else {
            self.titleImage.image = UIImage.asset(.user)
        }
     //   setupLayer()
    }
    private func setupLayer() {
  
        self.layoutIfNeeded()
        colorView.layoutIfNeeded()
        caGradientLayer?.removeFromSuperlayer()
        let layer = CALayer.getPBGradientLayer(bounds: colorView.bounds)
        colorView.layer.addSublayer(layer)
        caGradientLayer = layer
    }
}
