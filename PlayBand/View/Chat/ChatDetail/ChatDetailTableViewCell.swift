//
//  ChatDetailTableViewCell.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/6/10.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class ChatDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var otherSideImageView: UIImageView!
    @IBOutlet weak var otherSideTextView: UITextView!
    
    @IBOutlet weak var otherSideNameLabel: UILabel!
    @IBOutlet weak var mainNameLabel: UILabel!
    @IBOutlet weak var mainTextView: UITextView!
    @IBOutlet weak var mainImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        otherSideTextView.isHidden = true
        otherSideImageView.isHidden = true
        otherSideNameLabel.isHidden = true
        mainImage.isHidden = true
        mainTextView.isHidden = true
        mainNameLabel.isHidden = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellinMain(message: String, name: String, imageURL: String) {
        
        mainNameLabel.isHidden = false
        mainTextView.isHidden = false
        mainImage.isHidden = false
        mainTextView.text = message
        mainImage.lv_setImageWithURL(url: imageURL)
        mainNameLabel.text = name
    }
    
    func setupCellinOtherSide(message: String, name: String, imageURL: String) {
        
        otherSideTextView.isHidden = false
        otherSideImageView.isHidden = false
        otherSideNameLabel.isHidden = false
        otherSideTextView.text = message
        otherSideImageView.lv_setImageWithURL(url: imageURL)
        otherSideNameLabel.text = name
    }
    
    override func prepareForReuse() {
        
        otherSideTextView.isHidden = true
        otherSideImageView.isHidden = true
        otherSideNameLabel.isHidden = true
        mainImage.isHidden = true
        mainTextView.isHidden = true
        mainNameLabel.isHidden = true
        mainTextView.text = ""
        otherSideTextView.text = ""
    }
}
