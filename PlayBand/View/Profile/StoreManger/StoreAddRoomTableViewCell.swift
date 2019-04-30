//
//  StoreAddRoomTableViewCell.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/30.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class StoreAddRoomTableViewCell: UITableViewCell {
    
    enum CellType: String {
        
        case room = "團室名稱"
        case price = "每小時價錢"
        
        var description: String {
            switch self {
            case .room:
                return "Ex:大大練"
            case .price:
                return "Ex:500"
            }
        }
    }
    
    @IBAction func textFieldEnd() {
        delegate?.textFieldDidEnd(tableViewCell: self, firstTextField: firstTextField.text, secondTextField: secondTextField.text)
    }
    @IBOutlet weak var firstTitleLabel: UILabel!
    @IBOutlet weak var secondTitleLabel: UILabel!
    @IBOutlet weak var firstDescriptionLabel: UILabel!
    @IBOutlet weak var secondDescriptionLabel: UILabel!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    weak var delegate: StoreAddRoomCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellInRoom(delegate: StoreAddRoomCellDelegate, firstText: String?, secondText: String?) {
        
        firstTitleLabel.text = CellType.room.rawValue
        firstDescriptionLabel.text = CellType.room.description
        secondTitleLabel.text = CellType.price.rawValue
        secondDescriptionLabel.text = CellType.price.description
        firstTextField.placeholder = CellType.room.rawValue
        secondTextField.placeholder = CellType.price.rawValue
        self.delegate = delegate
        
        firstTextField.text = firstText
        secondTextField.text = secondText
        
    }
}

protocol StoreAddRoomCellDelegate: class {
    func textFieldDidEnd(tableViewCell: UITableViewCell, firstTextField: String?, secondTextField: String?)
}
