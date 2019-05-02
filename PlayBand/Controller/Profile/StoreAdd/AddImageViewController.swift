//
//  AddImageViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/30.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class AddImageViewController: EditPageViewController {

    override func buttonAction() {
        
        if images.count == 0 {
            
            self.addErrorAlertMessage(title: FirebaseEnum.fail.rawValue, message: "至少上傳一張圖片", completionHanderInDismiss: nil)
            return
        }
        
        guard let nextVC = self.storyboard?.instantiateViewController(
            withIdentifier: String(describing: StoreReviewViewController.self)) as? StoreReviewViewController else {
            return
        }

        nextVC.setupStoreData(storeData: storeData, images: images)
        self.navigationController?.pushViewController(nextVC, animated: true)
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
    var images: [UIImage] = []
    var storeData: StoreData?
    override func viewDidLoad() {
        super.viewDidLoad()
        pageName = "選擇圖片"
        descriptionText = "第一張為主要圖片\n最多七張"
        // Do any additional setup after loading the view.
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
        
        cell.setupCell(image: images[indexPath.row], storeAddImageDelegate: self, row: indexPath.row)
        return cell
    }
}

extension AddImageViewController: StoreAddImageDelegate {
    
    func buttonAction(cell: UITableViewCell) {
        
        guard let index = tableView.indexPath(for: cell) else {return}
        
        if index.row >= images.count {
            return
        } else {
            
            images.remove(at: index.row)
            let indexSet = IndexSet(arrayLiteral: index.section)
            tableView.reloadSections(indexSet, with: .automatic)
        }
    }
}

extension AddImageViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectImage: UIImage?

        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            selectImage = pickedImage
        }
        
        if let selectedImage = selectImage {
            
            let resizeImage = selectedImage.resizeImage(
                targetSize: CGSize(width: 500, height: selectedImage.size.height / selectedImage.size.width * 500))
            
            self.images.append(resizeImage)
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
