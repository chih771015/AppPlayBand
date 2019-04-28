//
//  NoDataView.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/28.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class NoDataView: UIView {

    let titleLabel = UILabel()
    
    func setupView(at someView: UIView?) {
        
        self.removeFromSuperview()
        guard let view = someView else {return}
        view.addSubview(self)
        
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        titleLabel.text = "沒有資料"
        self.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 80).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 80).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 80).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.leadingAnchor, constant: 80).isActive = true
        
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
