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

    var bookingDatas: [BookingData] = [] {
        
        didSet {
            
            tableView.reloadData()
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

        guard let sectionHeader = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(
                describing: ConfirmTableViewSectionHeaderView.self)) as? ConfirmTableViewSectionHeaderView else { return UIView()}
        sectionHeader.dateLabel.text = "\(bookingDatas[section].date.year) + \(bookingDatas[section].date.month) + \(bookingDatas[section].date.day)"
        sectionHeader.timeLabel.text = "總共\(bookingDatas[section].hour.count)小時"
        return sectionHeader
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bookingDatas[section].hour.count
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
        cell.titleLabel.text = "\(bookingDatas[indexPath.section].hour[indexPath.row])"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return bookingDatas.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}
