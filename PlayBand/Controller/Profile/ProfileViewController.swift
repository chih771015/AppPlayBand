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

        guard let nextViewController = UIStoryboard.photo.instantiateInitialViewController() else {return}
        present(nextViewController, animated: true, completion: nil)

    }

    @IBOutlet weak var userImage: ProfileUserPictureImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var user: UserData? {
        didSet {
            tableView.reloadData()
        }
    }
    private let datas: [ProfileContentCategory] = [.name, .band, .phone, .email, .facebook]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let uid = FirebaseSingle.shared.user().currentUser?.uid else {return}
        FirebaseSingle.shared.dataBase().collection("Users").document(uid).getDocument { [weak self] (document, error) in
            if let user = document.flatMap({
                $0.data().flatMap({ (data) in
                    return UserData(dictionary: data)
                })
            }) {
                self?.user = user
            } else {
                print("Document does not exist")
            }
        }
    }
    private func setupTableView() {

        tableView.lv_registerCellWithNib(
            identifier: String(describing: ProfileInformationTableViewCell.self),
            bundle: nil)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if user != nil {
            
            return datas.count
        } else {
            
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return datas[indexPath.row].cellForIndexPathInMain(indexPath, tableView: tableView, userData: user)
    }
}
