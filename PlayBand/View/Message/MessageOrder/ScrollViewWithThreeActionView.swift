//
//  ScrollViewWithThreeAction.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/13.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class ScrollViewWithThreeActionView: UIView {

    @IBOutlet private weak var topActionView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    private let topView = TopViewWithThreeButtonAndUnderLine()
    weak var delegate: ScrollViewWithThreeActionDelegate?
    var scrollViewFullSizeSubViews: [UIView] = []
    
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
            scrollView.isPagingEnabled = true
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
    
    func setupScrollViewSubViewFullSize(at conut: Int) {
        
        for _ in 0..<conut {
            
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(view)
        }
        
        setupScrollViewSubViewConstraints()
    }
    
    private func setupScrollViewSubViewConstraints() {
        
        let viewCount = scrollView.subviews.count
        
        for count in 0..<viewCount {
            let view = scrollView.subviews[count]
            view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
            if count == 0 {
                
                view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            } else {
                
                view.leadingAnchor.constraint(equalTo: scrollView.subviews[count - 1].trailingAnchor).isActive = true
            }
            if count == viewCount - 1 {
                
                view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
            }
        }
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

extension ScrollViewWithThreeActionView: ThreeActionDelegate {
    
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
