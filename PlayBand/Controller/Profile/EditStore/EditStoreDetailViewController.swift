//
//  EditStoreDetailViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/2.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class EditStoreDetailViewController: BaseStoreDetailViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func buttonAction() {
        
        let alert = UIAlertController(title: "請選擇要修改的資訊", message: nil, preferredStyle: .actionSheet)
        
        let actionInfo = UIAlertAction(title: "修改資訊", style: .default) { [weak self] _ in
            
            self?.presentEditInfo()
        }
        actionInfo.setValue(UIColor.playBandColorEnd, forKey: "titleTextColor")
        
        let actionPhoto = UIAlertAction(title: "修改照片", style: .default) { [weak self] _ in
            
            self?.presentEditPhoto()
        }
        actionPhoto.setValue(UIColor.playBandColorEnd, forKey: "titleTextColor")
        
        let actionRooms = UIAlertAction(title: "修改團室", style: .default) { [weak self] _ in
            
            self?.persentEditRooms()
        }
        actionRooms.setValue(UIColor.playBandColorEnd, forKey: "titleTextColor")
        
        let actionCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        actionCancel.setValue(UIColor.playBandColorEnd, forKey: "titleTextColor")
        
        alert.addAction(actionInfo)
        alert.addAction(actionPhoto)
        alert.addAction(actionRooms)
        alert.addAction(actionCancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func presentEditInfo() {
        guard let nextVC = UIStoryboard.profile.instantiateViewController(
            withIdentifier: String(
                describing: EditStoreInfoViewController.self
        )) as? EditStoreInfoViewController else {return}
        nextVC.storeData = self.storeData
        nextVC.getDataClosure = { [weak self] storeData in
            
            self?.storeData = storeData
            self?.tableView.reloadData()
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    private func presentEditPhoto() {
        
        guard let nextVC = UIStoryboard.profile.instantiateViewController(
            withIdentifier: String(
                describing: EditStorePhotoViewController.self
        )) as? EditStorePhotoViewController else {return}
        nextVC.storeData = self.storeData
        nextVC.getDataClosure = { [weak self] storeData in
            
            self?.storeData = storeData
            self?.tableView.reloadData()
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func persentEditRooms() {
        
        guard let nextVC = UIStoryboard.profile.instantiateViewController(
            withIdentifier: String(
                describing: EditStoreRoomViewController.self
        )) as? EditStoreRoomViewController else {return}
        nextVC.storeData = self.storeData
        nextVC.getDataClosure = { [weak self] storeData in
            
            self?.storeData = storeData
            self?.tableView.reloadData()
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
