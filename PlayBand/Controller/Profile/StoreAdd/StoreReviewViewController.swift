//
//  StoreReviewViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/1.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class StoreReviewViewController: BaseStoreViewController {
    
    var images: [UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setupStoreData(storeData: StoreData?, images: [UIImage]) {
        
        self.images = images
        self.storeData = storeData
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return datas[indexPath.row].cellForIndexPath(indexPath, tableView: tableView, data: storeData, images: images)
    }
    override func buttonAction() {
        print(storeData)
    }
}
