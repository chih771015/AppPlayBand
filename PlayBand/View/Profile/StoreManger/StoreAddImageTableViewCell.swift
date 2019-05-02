//
//  StoreAddImageTableViewCell.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/30.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class StoreAddImageTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBAction func buttonAction(_ sender: Any) {
        
        delegate?.buttonAction(cell: self)
    }
    weak var delegate: StoreAddImageDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(image: UIImage, storeAddImageDelegate: StoreAddImageDelegate,row: Int, url: String = String()) {
        if row == 0 {
            self.titleLabel.text = "這是主圖片"
        } else {
            self.titleLabel.text = "這是第 \(row + 1) 張圖片"
        }
        self.delegate = storeAddImageDelegate
        if url.isEmpty {
            titleImageView.image = image
        } else {
          titleImageView.lv_setImageWithURL(url: url)
        }
    }
}

protocol StoreAddImageDelegate: class {
    func buttonAction(cell: UITableViewCell)
}
