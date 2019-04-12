//
//  MessageStoreCheckViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/12.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class MessageStoreCheckViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            
            setupTableView()
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    private func setupTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.lv_registerCellWithNib(identifier: String(describing: MessageConfirmPageTableViewCell.self), bundle: nil)
    }
}

extension MessageStoreCheckViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MessageConfirmPageTableViewCell.self), for: indexPath) as? MessageConfirmPageTableViewCell else {
            return UITableViewCell()
        }
        cell.button.addTarget(self, action: #selector(checkUser), for: .touchUpInside)
        return cell
    }
    
    @objc func checkUser() {
        
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: MessageUserProfileViewController.self)) else {
            return
        }
        
        present(nextVC, animated: true, completion: nil)
    }
}
