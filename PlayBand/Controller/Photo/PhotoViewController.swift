//
//  PhotoViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/5.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit
//
//class PhotoViewController: UIViewController {
//
//    @IBAction func dismissVC() {
//
//        dismiss(animated: true, completion: nil)
//    }
//
//    @IBAction func chancePhoto() {
//
//        let imagePickVC = UIImagePickerController()
//        imagePickVC.sourceType = .photoLibrary
//        imagePickVC.delegate = self
//        present(imagePickVC, animated: true, completion: nil)
//    }
//
//    @IBAction func useCamera() {
//
//        let imagePickVC = UIImagePickerController()
//        imagePickVC.sourceType = .camera
//        imagePickVC.delegate = self
//   //     imagePickVC.allowsEditing = true
//        present(imagePickVC, animated: true, completion: nil)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//}
//
//extension PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//
//            dismiss(animated: true, completion: nil)
//        }
//    }
//}

class PhotoChoiceViewController: UIAlertController {
    
    var getImage = {}
    var presentVC: (UINavigationControllerDelegate & UIImagePickerControllerDelegate & UIViewController)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
    }
    
    deinit {
        print("dead")
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
            
            imagePickerController.sourceType = .photoLibrary
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
