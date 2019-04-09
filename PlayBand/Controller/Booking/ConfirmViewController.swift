//
//  ConfirmViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/9.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            
            setupTableView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.lv_registerCellWithNib(identifier: String(describing: ConfirmTableViewCell.self), bundle: nil)
        tableView.lv_registerHeaderWithNib(identifier: String(describing: ConfirmTableViewSectionHeaderView.self), bundle: nil)
        tableView.lv_registerHeaderWithNib(identifier: String(describing: ConfirmTableViewHeaderView.self), bundle: nil)
        
//        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: ConfirmTableViewHeaderView.self)) else {return}
//
         guard let headerView = UINib(nibName: String(describing: ConfirmTableViewHeaderView.self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ConfirmTableViewHeaderView else { return }
        
        //tableView.setTableHeaderView(headerView: headerView)
        tableView.shouldUpdateHeaderViewFrame()
        tableView.tableHeaderView = headerView
        
        
    }
    
}

extension ConfirmViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: ConfirmTableViewSectionHeaderView.self))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ConfirmTableViewCell.self), for: indexPath) as? ConfirmTableViewCell else {
            
            
            return UITableViewCell()}
        return cell
    }
}
