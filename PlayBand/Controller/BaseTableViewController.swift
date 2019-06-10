//
//  BaseTableViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/6/6.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class BaseTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
    }
    
    private func setupTableView() {
        
        if tableView == nil {
            
            let tableView = UITableView()
            view.stickSubView(tableView)
            self.tableView = tableView
            tableView.separatorStyle = .none
        }
        tableView.delegate = self
        tableView.dataSource = self
        setupTableViewCell()
    }
    
    func setupTableViewCell() {
        
    }

}

extension BaseTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
