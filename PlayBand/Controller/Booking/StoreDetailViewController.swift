//
//  StoreDetailViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/7.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class StoreDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {

            setupTableView()
        }
    }
    
    @IBAction func backAction() {
        
//        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var storeImage: UIImageView!
    private let datas: [StoreContentCategory] = [.information, .price, .time, .description]
    
    var storeData: StoreData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.storeImage.lv_setImageWithURL(url: storeData?.photourl ?? "")
    }

    private func setupTableView() {

        tableView.delegate = self
        tableView.dataSource = self
        tableView.lv_registerCellWithNib(
            identifier: String(describing: StoreDescriptionTableViewCell.self),
            bundle: nil)
        tableView.lv_registerCellWithNib(
            identifier: String(describing: StoreInformationTableViewCell.self),
            bundle: nil)
    }
    
//    private func setupNavigationBar() {
//
//        self.navigationController?.navigationBar.isHidden = true
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setupNavigationBar()
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.isHidden = false
//    }
}

extension StoreDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return datas[indexPath.row].cellForIndexPath(indexPath, tableView: tableView, data: self.storeData)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextVC = segue.destination as? CalendarViewController else {return}
        nextVC.storeData = self.storeData
    }
}
