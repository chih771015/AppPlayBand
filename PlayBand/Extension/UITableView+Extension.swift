//
//  UITableView+Extension.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/3.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

extension UITableView {

    func lv_registerCellWithNib(identifier: String, bundle: Bundle?) {

        let nib = UINib(nibName: identifier, bundle: bundle)

        register(nib, forCellReuseIdentifier: identifier)
    }

    func lv_registerHeaderWithNib(identifier: String, bundle: Bundle?) {

        let nib = UINib(nibName: identifier, bundle: bundle)

        register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }

    func setTableHeaderView(headerView: UIView) {
        headerView.translatesAutoresizingMaskIntoConstraints = false

        self.tableHeaderView = headerView

        // ** Must setup AutoLayout after set tableHeaderView.
//        headerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        headerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    func shouldUpdateHeaderViewFrame() -> Bool {
        guard let headerView = self.tableHeaderView else { return false }
        let oldSize = headerView.bounds.size
        headerView.layoutIfNeeded()
        let newSize = headerView.bounds.size
        return oldSize != newSize
    }
    
}
