//
//  ScrollViewWithThreeAction.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/13.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class ScrollViewWithThreeAction: UIView {

    @IBOutlet weak var topActionView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    private let topView = TopViewWithThreeButtonAndUnderLine()
    weak var delegate: ScrollViewWithThreeActionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if topActionView == nil {
            
            let view = UIView()
            topActionView = view
            view.backgroundColor = .white
            addSubview(view)
        }
        
        if scrollView == nil {
            
            let scrollView = UIScrollView()
            self.scrollView = scrollView
            self.addSubview(scrollView)
        }
        scrollView.backgroundColor = .red
        setupConstraints()
        topActionView.stickSubView(topView)
        topView.delegate = self
    }
    
    private func setupConstraints() {
        
        setupTopView()
        setupScrollView()
    }
    
    func setupTitle(first: String, second: String, third: String) {
        
        topView.setupTitle(first: first, second: second, third: third)
    }
    
    private func setupTopView() {
        
        topActionView.translatesAutoresizingMaskIntoConstraints = false
        topActionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        setupLeadTrailingAnchor(view: topActionView)
        topActionView.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    private func setupScrollView() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: topActionView.bottomAnchor).isActive = true
        setupLeadTrailingAnchor(view: scrollView)
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func setupLeadTrailingAnchor(view: UIView) {
        
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension ScrollViewWithThreeAction: ThreeActionDelegate {
    
    func leftAction() {
        delegate?.leftAction()
    }
    
    func rightAction() {
        delegate?.rightAction()
    }
    
    func centerAction() {
        delegate?.centerAction()
    }
}

protocol ScrollViewWithThreeActionDelegate: class {
    
    func leftAction()
    func rightAction()
    func centerAction()
}




