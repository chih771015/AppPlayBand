//
//  StoreTitleImageTableViewCell.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/23.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class StoreTitleImageTableViewCell: UITableViewCell {
    
    var images: [String] = [] {
        
        didSet {
            
            collectionView.reloadData()
            pageControl.numberOfPages = images.count
        }
    }
    var uiImages: [UIImage] = [] {
        
        didSet {
            
            collectionView.reloadData()
            pageControl.numberOfPages = uiImages.count
            isURL = false
        }
    }
    
    private var isURL = true
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            setupCollectionView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCollectionView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupCollectionView() {
        
        collectionView.lv_reqisterCellWithNib(
            identifier: String(describing: StoreImageCollectionViewCell.self),
            bundle: nil)
        collectionView.delegate = self
        collectionView.dataSource = self
        guard let collectionViewLayout = collectionView
            .collectionViewLayout as? UICollectionViewFlowLayout else {return}
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.sectionInset = UIEdgeInsets.zero
        collectionViewLayout.scrollDirection = .horizontal
        
    }
    
}

extension StoreTitleImageTableViewCell: UICollectionViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return self.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isURL {
            return images.count
        } else {
            return uiImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: StoreImageCollectionViewCell.self),
            for: indexPath) as? StoreImageCollectionViewCell else {return UICollectionViewCell()}
        if isURL {
            cell.setupImage(url: images[indexPath.row])
        } else {
            cell.setupImageInImage(image: uiImages[indexPath.row])
        }
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let nowX = scrollView.contentOffset.x
        let viewWidth = self.collectionView.bounds.width
        let page = nowX / viewWidth
        self.pageControl.currentPage = Int(page)
    }
}
