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
        guard let accountCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditTableViewCell else { return }
        guard let passwordCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? EditTableViewCell else { return }
        guard let account = accountCell.textField.text else {
            return
        }
        guard let password = passwordCell.textField.text else {
            return
        }
        FirebaseSingle.shared.signUpAccount(email: account, password: password, completionHandler: { result, error in
            
            guard result != nil else {
                
                print(error)
                return
            }
            print(result)
            
            FirebaseSingle.shared.signInAccount(email: account, password: password, completionHandler: { (result, error) in
                
                guard result != nil else {
                    
                    print(error)
                    return
                }
                print(result)
                
            })
        })
    }
    
    var dataSignUp: [ProfileContentCategory] = [.account, .password, .email, .name, .phone, .band, .facebook]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSignUp.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return dataSignUp[indexPath.row].cellForIndexPathInEdit(indexPath, tableView: tableView)
    }
}
