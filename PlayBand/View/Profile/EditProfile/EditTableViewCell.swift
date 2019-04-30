//
//  EditTableViewCell.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/5.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class EditTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupEditCell(placeholder: String, text: String? = nil, tag: Int, textFieldDelgate: UITextFieldDelegate, description: String? = nil) {
        setupTextField(placeholder: placeholder, tag: tag, textFieldDelgate: textFieldDelgate, text: text, description: description)
    }
    func setupEditPasswordCell(placeholder: String, tag: Int, textFieldDelgate: UITextFieldDelegate, text: String? = nil, description: String? = nil) {
         setupTextField(placeholder: placeholder, tag: tag, textFieldDelgate: textFieldDelgate, text: text, description: description)
        textField.isSecureTextEntry = true
    }
    func setupEditPickerCell(placeholder: String, tag: Int, textFieldDelgate: UITextFieldDelegate) {
        
        setupTextField(placeholder: placeholder, tag: tag, textFieldDelgate: textFieldDelgate, text: UsersKey.Status.user.rawValue)
        let pickView = UIPickerView()
        pickView.delegate = self
        pickView.dataSource = self
        textField.inputView = pickView
    }
    
    private func setupTextField(placeholder: String, tag: Int, textFieldDelgate: UITextFieldDelegate, text: String?, description: String? = nil) {
        textField.delegate = textFieldDelgate
        textField.placeholder = placeholder
        titleLabel.text = placeholder
        self.textField.text = text
        textField.tag = tag
        descriptionLabel.text = description
    }
    
    override func prepareForReuse() {
        
        textField.inputView = nil
        textField.isSecureTextEntry = false
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
