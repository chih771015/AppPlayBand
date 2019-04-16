//
//  SearchStoreViewController
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/6.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class SearchStoreViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {

            tableViewSetup()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    private func tableViewSetup() {

        tableView.dataSource = self
        tableView.delegate = self
        tableView.lv_registerCellWithNib(identifier: String(describing: SearchStoreTableViewCell.self), bundle: nil)
    }
}

extension SearchStoreViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(
                describing: SearchStoreTableViewCell.self
            ),
            for: indexPath
        ) as? SearchStoreTableViewCell else { return UITableViewCell()}
        cell.setupCell(title: "test",
                       imageURL: Test.url.rawValue
        )
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 175
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let nextViewController = self.storyboard?.instantiateViewController(
            withIdentifier: String(describing: StoreDetailViewController.self)
        ) else {return}
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}


enum Test: String {
    
    case url = "https://firebasestorage.googleapis.com/v0/b/test-3dcea.appspot.com/o/27540325_574597332884961_4955653517050363908_n.jpg?alt=media&token=d61c16a3-b669-426b-a2bc-04e2ba98b7af"
}
