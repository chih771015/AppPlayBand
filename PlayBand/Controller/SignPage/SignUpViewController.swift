//
//  SignUpViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/11.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class SignUpViewController: EditProfileViewController {

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
