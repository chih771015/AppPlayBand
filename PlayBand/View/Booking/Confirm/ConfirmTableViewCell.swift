//
//  ConfirmTableViewCell.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/9.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class ConfirmTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var colorView: UIView! {
        
        didSet {
            
            colorView.layer.cornerRadius = 19
            colorView.addShadow()
        }
    }
    
    var caGradientLayer: CAGradientLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(text: String) {
        
        self.layoutIfNeeded()
        
        caGradientLayer?.removeFromSuperlayer()
        self.titleLabel.setupTextInPB(text: text)
        titleLabel.textAlignment = .center
        let layer = CALayer.getPBGradientLayer(bounds: colorView.bounds, cornerRadius: 19)
        colorView.layer.addSublayer(layer)
        caGradientLayer = layer
    }
}
