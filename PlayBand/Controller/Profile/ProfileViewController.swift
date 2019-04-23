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

        let nextViewController = PhotoChoiceViewController(title: "上傳圖片", message: "請選擇圖片", preferredStyle: .actionSheet)
        nextViewController.presentVC = self
        present(nextViewController, animated: true, completion: nil)

    }

    @IBOutlet weak var userImage: ProfileUserPictureImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var colorView: UIView!
    
    var user: UserData? {
        
        didSet {
            tableView.reloadData()
            guard let url = user?.photoURL else {return}
            userImage.lv_setImageWithURL(url: url)
        }
    }
    private let datas: [ProfileContentCategory] = [.name, .band, .phone, .email, .facebook]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupColorView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.user = FirebaseManger.shared.userData
    }
    
    private func setupNavigationBar() {
    
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    private func setupColorView() {
        // Do any additional setup after loading the view.
//        let gradientLayer = CAGradientLayer()
////        colorView.layoutIfNeeded()
//        gradientLayer.frame = colorView.bounds
//        let startColor = UIColor.playBandColorGreen
//        let endColor = UIColor.playBandColorEnd
//        gradientLayer.colors = [startColor?.cgColor, endColor?.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
//        colorView.layer.addSublayer(gradientLayer)
        colorView.addGradientColor()
        colorView.layer.shadowOffset = CGSize(width: 3, height: 3)
        colorView.layer.shadowOpacity = 0.7
        colorView.layer.shadowColor = UIColor.lightGray.cgColor
        
    }
    private func setupTableView() {

        tableView.lv_registerCellWithNib(
            identifier: String(describing: ProfileInformationTableViewCell.self),
            bundle: nil)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 5))
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
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 8
//    }
//    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
//        return 0.5
//    }
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectImage: UIImage?
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            selectImage = pickedImage
        }
        
        let uniqueString = NSUUID().uuidString
        
        if let selectedImage = selectImage {
            
            let resizeImage = selectedImage.resizeImage(targetSize: CGSize(width: 500, height: selectedImage.size.height / selectedImage.size.width * 500))
            
            FirebaseManger.shared.uploadIamge(uniqueString: uniqueString, image: resizeImage) { (result) in
                
                switch result {
                    
                case .success(let string):
                    UIAlertController.alertMessageAnimation(title: string, message: nil, viewController: self, completionHanderInDismiss: nil)
                    FirebaseManger.shared.getUserInfo()
                
                case .failure(let error):
                    
                      UIAlertController.alertMessageAnimation(title: FirebaseEnum.fail.rawValue, message: error.localizedDescription, viewController: self, completionHanderInDismiss: nil)
                }
            }
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
