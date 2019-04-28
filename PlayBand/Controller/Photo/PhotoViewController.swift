//
//  PhotoViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/5.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class PhotoChoiceViewController: UIAlertController {
    
    var getImage = {}
    var presentVC: (UINavigationControllerDelegate & UIImagePickerControllerDelegate & UIViewController)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
    }

    private func setupAction() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = presentVC
        
        let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { [weak self] (_) in
            
            imagePickerController.sourceType = .photoLibrary
            guard let nextVC = self?.presentVC else {return}
            nextVC.present(imagePickerController, animated: true, completion: nil)
        }
        
        let imageFromCameraAction = UIAlertAction(title: "相機", style: .default) { [weak self] (_) in
            
            imagePickerController.sourceType = .camera
            guard let nextVC = self?.presentVC else {return}
            nextVC.present(imagePickerController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) {[weak self] (_) in
            
            self?.dismiss(animated: true, completion: nil)
        }
        self.addAction(imageFromLibAction)
        self.addAction(imageFromCameraAction)
        self.addAction(cancelAction)
    }
}
