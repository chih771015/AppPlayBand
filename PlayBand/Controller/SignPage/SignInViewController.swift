//
//  SignInViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/11.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    let firebase = FirebaseSingle.shared
    
    @IBAction func signInAction() {
        guard let account = accountTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        firebase.signInAccount(email: account, password: password) { (result, error) in
            print(result?.additionalUserInfo?.profile)
            print(error)
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
