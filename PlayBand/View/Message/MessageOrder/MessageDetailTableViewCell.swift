//
//  MessageDetailTableViewCell.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/25.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class MessageDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        button.isHidden = false
        photoImageView.isHidden = true
    }
    func setupCell(title: String, description: String) {
        
        self.titleLabel.text = title
        self.descriptionLabel.text = description
    }
    
    func setupCellHavePhoto(title: String, description: String, imageURL: String?) {
        
        setupCell(title: title, description: description)
        guard let url = imageURL else { return }
        photoImageView.lv_setImageWithURL(url: url)
        photoImageView.isHidden = false
    }
}
