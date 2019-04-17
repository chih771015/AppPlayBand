//
//  SignInViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/11.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    private let firebase = FirebaseManger.shared
    
    @IBAction func signInAction() {
        
        guard let account = accountTextField.text, accountTextField.text?.count != 0 else {
            
            UIAlertController.alertMessageAnimation(title: FirebaseEnum.fail.rawValue, message: "請輸入帳號", viewController: self, completionHanderInDismiss: nil)
            return
        }
        guard let password = passwordTextField.text, passwordTextField.text?.count != 0 else {
            
            UIAlertController.alertMessageAnimation(title: FirebaseEnum.fail.rawValue, message: "請輸入密碼", viewController: self, completionHanderInDismiss: nil)
            return
        }
        
        firebase.signInAccount(email: account, password: password) {[weak self] (result, error) in
            if error != nil {
                
                UIAlertController.alertMessageAnimation(title: FirebaseEnum.fail.rawValue, message: error?.localizedDescription, viewController: self, completionHanderInDismiss: nil)
            } else {
                
                let alert = UIAlertController(title: nil, message: "登入成功", preferredStyle: .alert)
                self?.present(alert, animated: true) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        alert.dismiss(animated: true, completion: nil)
                        let mainVC = UIStoryboard.main.instantiateInitialViewController()
                        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
                        appDelegate.window?.rootViewController = mainVC
                    })
                }
            }
        }
    }
    @IBAction func unwindSegue(sender: UIStoryboardSegue) {
        
    }
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var guestButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var changeModelButton: UIButton!
    
    @IBAction func changeModelAction() {
    }
    @IBOutlet weak var accountTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func guestAction() {
        
        let mainVC = UIStoryboard.main.instantiateInitialViewController()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        appDelegate.window?.rootViewController = mainVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
