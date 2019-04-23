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
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        guard let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {return}
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.itemSize = self.bounds.size
        collectionViewLayout.sectionInset = UIEdgeInsets.zero
        collectionViewLayout.scrollDirection = .horizontal
       // collectionView.setCollectionViewLayout(collectionViewLayout, animated: true)
    }
    
}

extension StoreTitleImageTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: StoreImageCollectionViewCell.self),
            for: indexPath) as? StoreImageCollectionViewCell else {return UICollectionViewCell()}
        
        cell.setupImage(url: images[indexPath.row])
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let nowX = scrollView.contentOffset.x
        let viewWidth = self.collectionView.bounds.width
        let page = nowX / viewWidth
        self.pageControl.currentPage = Int(page)
    }
}
