//
//  EditStorePhotoViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/3.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class EditStorePhotoViewController: BaseEditViewController {
    
    override func buttonAction() {
        
        if images.count == 0 {
            
            self.addErrorAlertMessage(title: FirebaseEnum.fail.rawValue, message: "至少要有一張圖片")
            return
        }
        
        guard var storeData = self.storeData else {return}
        var urls = self.urls
        PBProgressHUD.addLoadingView(animated: true)
        if urls.filter({$0.isEmpty}).isEmpty {
            
            storeData.photourl = urls[0]
            urls.removeFirst()
            storeData.images = urls
            self.upDataStoreRoom(storeData: storeData)
        } else {
            var images: [UIImage] = []
            for index in 0 ..< self.images.count {
                
                if urls[index].isEmpty {
                    
                    images.append(self.images[index])
                }
            }
            urls = urls.filter({$0.isEmpty == false})
            FirebaseManger.shared.uploadImagesAndGetURL(images: images) { [weak self] (result) in
                switch result {
                    
                case .success(let urlsData):
                    
                    urls += urlsData
                    storeData.photourl = urls[0]
                    urls.removeFirst()
                    storeData.images = urls
                    self?.upDataStoreRoom(storeData: storeData)
                case .failure(let error):
                    PBProgressHUD.dismissLoadingView(animated: true)
                    
                    self?.addErrorAlertMessage(
                        title: FirebaseEnum.fail.rawValue, message: error
                    .localizedDescription)
                }
            }
        }
    }
    @IBAction func barButtonAction(_ sender: Any) {
        
        if images.count > 6 {
            
            return
        }
        
        let nextVC = PhotoChoiceViewController(
            title: PhotoEnum.title.rawValue, message: PhotoEnum.message.rawValue, preferredStyle: .actionSheet)
        nextVC.presentVC = self
        present(nextVC, animated: true, completion: nil)
    }
    var getDataClosure: ((StoreData) -> Void)?
    var urls: [String] = []
    var images: [UIImage] = []
    var storeData: StoreData? {
        
        didSet {
            
            setupURLS()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        pageName = "修改圖片"
        descriptionText = "第一張為主要圖片\n最多七張"
    }
    override func setupTableView() {
        super.setupTableView()
        tableView.lv_registerCellWithNib(identifier: String(describing: StoreAddImageTableViewCell.self), bundle: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(
                describing: StoreAddImageTableViewCell.self), for: indexPath) as? StoreAddImageTableViewCell else {
                    
                    return UITableViewCell()
        }
        
        cell.setupCell(
            image: images[indexPath.row],
            storeAddImageDelegate: self,
            row: indexPath.row,
            url: urls[indexPath.row])
        return cell
    }
    
    private func setupURLS() {
        
        var urls: [String] = []
        
        guard let storeData = self.storeData else {return}
        
        urls.append(storeData.photourl)
        self.images.append(UIImage())
        for image in storeData.images {
            
            urls.append(image)
            self.images.append(UIImage())
        }
        self.urls = urls
    }
    
    private func upDataStoreRoom(storeData: StoreData) {
        
        FirebaseManger.shared.updataStoreData(storeData: storeData) { [weak self] (result) in
            PBProgressHUD.dismissLoadingView(animated: true)
            switch result {
                
            case .success(let message):
                
                self?.addSucessAlertMessage(
                    title: message, message: nil, completionHanderInDismiss: { [weak self] in
                    
                        if let closure = self?.getDataClosure {
                            
                            closure(storeData)
                        }
                        
                    FirebaseManger.shared.replaceStoreData(storeData: storeData)
                    self?.navigationController?.popViewController(animated: true)
                })
            case .failure(let error):
                
                self?.addErrorAlertMessage(
                    title: FirebaseEnum.fail.rawValue, message: error.localizedDescription)
            }
        }
    }
}

extension EditStorePhotoViewController: StoreAddImageDelegate {
    
    func buttonAction(cell: UITableViewCell) {
        
        guard let index = tableView.indexPath(for: cell) else {return}
        
        if index.row >= images.count {
            return
        } else {
            
            images.remove(at: index.row)
            urls.remove(at: index.row)
            let indexSet = IndexSet(arrayLiteral: index.section)
            tableView.reloadSections(indexSet, with: .automatic)
        }
    }
}

extension EditStorePhotoViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectImage: UIImage?
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            selectImage = pickedImage
        }
        
        if let selectedImage = selectImage {
            
            let resizeImage = selectedImage.resizeImage(
                targetSize: CGSize(width: 500, height: selectedImage.size.height / selectedImage.size.width * 500))
            
            self.images.append(resizeImage)
            self.urls.append(String())
            if images.count == 1 {
                
                tableView.reloadData()
            } else {
                
                let indexPath = IndexPath(row: (images.count - 1), section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
