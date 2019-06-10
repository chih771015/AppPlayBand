//
//  ChatMainViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/6/6.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class ChatMainViewController: BaseTableViewController {
    
    @IBAction func switchChatModel(_ sender: Any) {
        
    }
    @IBAction func actionAddChatStore(_ sender: Any) {
        
    }
    let userManager = UserManager()
    let storeManager = StoreManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupTableViewCell() {
        
        tableView.lv_registerCellWithNib(identifier: String(describing: ChatMainTableViewCell.self), bundle: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ChatMainTableViewCell.self), for: indexPath
            ) as? ChatMainTableViewCell else {
            
            return UITableViewCell()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = UIStoryboard.chat.instantiateViewController(withIdentifier: String(describing: ChatDetailViewController.self))
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
