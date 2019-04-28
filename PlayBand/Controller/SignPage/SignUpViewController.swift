//
//  SignUpViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/11.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class SignUpViewController: EditProfileViewController {
    
    @IBAction func signUpAction() {
        
        guard let accountCell = tableView.cellForRow(
            at: IndexPath(row: 0, section: 0)) as? EditTableViewCell else { return }
        guard let passwordCell = tableView.cellForRow(
            at: IndexPath(row: 1, section: 0)) as? EditTableViewCell else { return }
        guard let account = accountCell.textField.text else {
            return
        }
        guard let password = passwordCell.textField.text else {
            return
        }
        FirebaseManger.shared.signUpAccount(
            email: account,
            password: password,
            completionHandler: { [weak self] result, error in
                print(result)
                guard result != nil else {
                    guard let errorConfirm = error else {return}
                    print(errorConfirm)
                    
                    self?.addErrorAlertMessage(title: FirebaseEnum.fail.rawValue, message: errorConfirm.localizedDescription, completionHanderInDismiss: nil)

                    return
            }

            FirebaseManger.shared.signInAccount(
                email: account,
                password: password,
                completionHandler: { [weak self] (result, error) in
                
                guard result != nil else {
                    
                    self?.addErrorAlertMessage(title: FirebaseEnum.fail.rawValue, message: error?.localizedDescription, completionHanderInDismiss: nil)
                    
                    return
                }
                
                    self?.addSucessAlertMessage(title: "歡迎進入", message: nil, completionHanderInDismiss: {
                        
                        guard let rootVC = UIStoryboard.main.instantiateInitialViewController() else {return}
                        guard let appdelgate = UIApplication.shared.delegate as? AppDelegate else {return}
                        appdelgate.window?.rootViewController = rootVC
                        self?.presentedViewController?.dismiss(animated: false, completion: nil)
                        self?.dismiss(animated: false, completion: nil)
                        
                    })
                    
//                let nextVC = UIAlertController(title: "歡迎進入", message: nil, preferredStyle: .alert)
//                    self?.present(nextVC, animated: true, completion: { 
//                        
//                        nextVC.dismiss(animated: true, completion: { [weak self] in
//                            
//                            guard let rootVC = UIStoryboard.main.instantiateInitialViewController() else {return}
//                            guard let appdelgate = UIApplication.shared.delegate as? AppDelegate else {return}
//                            appdelgate.window?.rootViewController = rootVC
//                            self?.presentedViewController?.dismiss(animated: false, completion: nil)
//                            self?.dismiss(animated: false, completion: nil)
//                        })
//                    })
            })
        })
    }
    
    var dataSignUp: [ProfileContentCategory] = [.account, .password, .email, .name,
                                                .phone, .band, .facebook, .userStatus]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSignUp.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return dataSignUp[indexPath.row].cellForIndexPathInEdit(
            indexPath, tableView: tableView, textFieldDelegate: self)
    }
}

extension SignUpViewController {
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
