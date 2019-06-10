//
//  ChatDetailViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/6/10.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class ChatDetailViewController: BaseTableViewController {
    
    
    
    @IBAction func sendAction() {
        
        
    }
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupTableViewCell() {
        
        tableView.lv_registerCellWithNib(identifier: String(describing: ChatDetailTableViewCell.self), bundle: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ChatDetailTableViewCell.self), for: indexPath
            ) as? ChatDetailTableViewCell else {
                
                return UITableViewCell()
        }
     
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}
