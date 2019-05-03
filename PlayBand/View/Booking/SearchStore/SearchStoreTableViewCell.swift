//
//  SearchStoreTableViewCell.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/6.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class SearchStoreTableViewCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(title: String, imageURL: String, city: String, price: String) {
        
        self.titleLabel.text = title
        self.titleLabel.setTextSpacingBy(value: 1.5)
        self.titleImageView.lv_setImageWithURL(url: imageURL)
        self.cityLabel.text = city
        self.cityLabel.setTextSpacingBy(value: 1.5)
        let priceTitle = "每小時 " + price
        self.priceLabel.text = priceTitle
        self.priceLabel.setTextSpacingBy(value: 1.5)

    }
}
