//
//  PasswordChangeViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/18.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class PasswordChangeViewController: UIViewController {

    @IBAction func changePasswordAction() {
        guard let password = passwordTextField.text else {
            
             UIAlertController.alertMessageAnimation(
                title: FirebaseEnum.fail.rawValue,
                message: ProfileEnum.textFieldNoValue.rawValue,
                viewController: self,
                completionHanderInDismiss: nil)
            return
        }
        guard let confirm = confirmTextField.text else {
            
            UIAlertController.alertMessageAnimation(
                title: FirebaseEnum.fail.rawValue,
                message: ProfileEnum.textFieldNoValue.rawValue,
                viewController: self,
                completionHanderInDismiss: nil)
            return
        }
        
        if password == confirm {
            firebase.changePassword(password: password) {[weak self] (result) in
                
                switch result {

                case .success(let data):
                    
                    UIAlertController.alertMessageAnimation(
                        title: data,
                        message: nil,
                        viewController: self,
                        completionHanderInDismiss: {
                        
                        self?.navigationController?.popToRootViewController(animated: true)
                        })
                case .failure(let error):
                    
                    UIAlertController.alertMessageAnimation(
                        
                        title: FirebaseEnum.fail.rawValue,
                        message: error.localizedDescription,
                        viewController: self,
                        completionHanderInDismiss: nil)
                }
            }
            
        } else {
            
            UIAlertController.alertMessageAnimation(title: FirebaseEnum.fail.rawValue, message: ProfileEnum.passwordNotSame.rawValue, viewController: self, completionHanderInDismiss: nil)
            
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmTextField: UITextField!
    
    private let firebase = FirebaseManger.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
