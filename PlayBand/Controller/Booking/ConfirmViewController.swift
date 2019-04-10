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

    var bookingDatas: [BookingData] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    private func setupTableView() {

        tableView.delegate = self
        tableView.dataSource = self
        tableView.lv_registerCellWithNib(identifier: String(describing: ConfirmTableViewCell.self), bundle: nil)
        tableView.lv_registerHeaderWithNib(
            identifier: String(
                describing: ConfirmTableViewSectionHeaderView.self
            ),
            bundle: nil
        )

         guard let headerView = UINib(
            nibName: String(describing: ConfirmTableViewHeaderView.self),
            bundle: nil
            ).instantiate(
                withOwner: nil,
                options: nil)[0] as? ConfirmTableViewHeaderView
            else { return }

        tableView.tableHeaderView = headerView

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        guard let headerView = tableView.tableHeaderView else { return }
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//        
//        let headerWidth = headerView.bounds.size.width
//        let temporaryWidthConstraints = NSLayoutConstraint.constraints(
//            withVisualFormat: "[headerView(width)]",
//            options: NSLayoutConstraint.FormatOptions(rawValue: UInt(0)),
//            metrics: ["width": headerWidth],
//            views: ["headerView": headerView])
//        
//        headerView.addConstraints(temporaryWidthConstraints)
//        headerView.setNeedsLayout()
//        headerView.layoutIfNeeded()
//
//        let headerSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//        let height = headerSize.height
//        var frame = headerView.frame
//        frame.size.height = height
//        headerView.frame = frame
//        self.tableView.tableHeaderView = headerView
//        headerView.removeConstraints(temporaryWidthConstraints)
//        headerView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(tableView.tableHeaderView?.frame)
    }
}

extension ConfirmViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        return tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: ConfirmTableViewSectionHeaderView.self))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(
                describing: ConfirmTableViewCell.self
            ),
            for: indexPath
        ) as? ConfirmTableViewCell else {

                return UITableViewCell()
            }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        for bookingdate in bookingDatas {
            
            bookingdate.year
            bookingdate.month
            bookingdate.day
            
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}
