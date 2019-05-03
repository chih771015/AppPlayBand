//
//  PhotoViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/5.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit
import AVKit

class PhotoChoiceViewController: UIAlertController {
    
    var presentVC: (UINavigationControllerDelegate & UIImagePickerControllerDelegate & UIViewController)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
    }

    private func setupAction() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = presentVC
        guard let nextVC = self.presentVC else {return}
        
        let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { [weak self] (_) in
            imagePickerController.sourceType = .photoLibrary
            
            self?.checkPhotoAndPresent(nextVC: nextVC, imagePickerController: imagePickerController)
        }
        
        imageFromLibAction.setValue(UIColor.playBandColorEnd, forKey: "titleTextColor")

        let imageFromCameraAction = UIAlertAction(title: "相機", style: .default) { [weak self] (_) in
            
            imagePickerController.sourceType = .camera
            self?.checkPhotoAndPresent(nextVC: nextVC, imagePickerController: imagePickerController)
        }
        imageFromCameraAction.setValue(UIColor.playBandColorEnd, forKey: "titleTextColor")

        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) {[weak self] (_) in
            
            self?.dismiss(animated: true, completion: nil)
        }
        
        cancelAction.setValue(UIColor.playBandColorEnd, forKey: "titleTextColor")
        self.addAction(imageFromLibAction)
        self.addAction(imageFromCameraAction)
        self.addAction(cancelAction)
    }
    
    private func checkPhotoAndPresent(nextVC: UIViewController, imagePickerController: UIImagePickerController) {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (bool) in
                if bool {
                    
                    nextVC.present(imagePickerController, animated: true, completion: nil)
                }
            })
        case .denied, .restricted:
            
            let alertController = UIAlertController (title: "相機啟用失敗", message: "相機服務未啟用", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "設定", style: .default) { (_) -> Void in
                
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "確認", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            
            nextVC.present(alertController, animated: true, completion: nil)
            return
        case .authorized:
            print("Authorized, proceed")
            nextVC.present(imagePickerController, animated: true)
        @unknown default:
            fatalError()
        }
    }
}
