//
//  MJRefresh.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/28.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import MJRefresh

extension UITableView {
    
    func addRefreshHeader(refreshingBlock: @escaping () -> Void) {
        
        mj_header = MJRefreshNormalHeader(refreshingBlock: refreshingBlock)
    }
    
    func endHeaderRefreshing() {
        
        mj_header.endRefreshing()
    }
    
    func beginHeaderRefreshing() {
        
        mj_header.beginRefreshing()
    }
}
