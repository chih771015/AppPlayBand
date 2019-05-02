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
            
            self.addErrorAlertMessage(title: FirebaseEnum.fail.rawValue, message: "請輸入帳號", completionHanderInDismiss: nil)
            
            return
        }
        guard let password = passwordTextField.text, passwordTextField.text?.count != 0 else {
            
            self.addErrorAlertMessage(title: FirebaseEnum.fail.rawValue, message: "請輸入密碼", completionHanderInDismiss: nil)
            
            return
        }
        PBProgressHUD.addLoadingView(at: view, animated: true)
        firebase.signInAccount(
        email: account, password: password) {[weak self] (result, error) in
            
            if error != nil {
                PBProgressHUD.dismissLoadingView(animated: true)
                self?.addErrorAlertMessage(title: FirebaseEnum.fail.rawValue, message: error?.localizedDescription, completionHanderInDismiss: nil)

            } else {
                
                self?.addSucessAlertMessage(title: nil, message: "登入成功", completionHanderInDismiss: {
                    
                    let mainVC = UIStoryboard.main.instantiateInitialViewController()
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
                    appDelegate.window?.rootViewController = mainVC
                })
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
