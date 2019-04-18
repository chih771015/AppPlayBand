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
    
    func setupEditPickerCell(placehoder: String) {
        
        let pickView = UIPickerView()
        pickView.delegate = self
        pickView.dataSource = self
        textField.inputView = pickView
        textField.placeholder = placehoder
    }
}

extension EditTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return UsersKey.Status.user.rawValue
        } else {
            return UsersKey.Status.manger.rawValue
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            textField.text = UsersKey.Status.user.rawValue
        } else {
            textField.text = UsersKey.Status.manger.rawValue
        }
    }
}


