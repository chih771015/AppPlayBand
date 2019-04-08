//
//  ProfileViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/3.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.delegate = self
            tableView.dataSource = self
            setupTableView()
        }
    }
    
    @IBAction func presentPhotoVC() {
        
        guard let vc = UIStoryboard.photo.instantiateInitialViewController() else {return}
        present(vc, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var userImage: ProfileUserPictureImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    private let datas: [ProfileContentCategory] = [.name, .band, .phone, .email, .facebook]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    private func setupTableView() {
        
        tableView.lv_registerCellWithNib(identifier: String(describing: ProfileInformationTableViewCell.self), bundle: nil)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return datas[indexPath.row].cellForIndexPathInMain(indexPath, tableView: tableView)
    }
}
