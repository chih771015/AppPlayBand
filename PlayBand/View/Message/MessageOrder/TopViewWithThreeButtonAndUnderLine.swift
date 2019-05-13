//
//  TopViewWithThreeButtonAndUnderLine.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/13.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class TopViewWithThreeButtonAndUnderLine: UIView {

    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var buttonCenter: UIButton!
    @IBOutlet weak var buttonRight: UIButton!
    @IBOutlet weak var underLineView: UIView!
    weak var delegate: ThreeActionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if buttonLeft == nil {
            
            buttonLeft = setupBaseButton()
            buttonLeft.addTarget(self, action: #selector(buttonLeftAction), for: .touchUpInside)
        }
        if buttonCenter == nil {
            
            buttonCenter = setupBaseButton()
            buttonCenter.addTarget(self, action: #selector(buttonCenterAction), for: .touchUpInside)
        }
        if buttonRight == nil {
            
            buttonRight = setupBaseButton()
            buttonRight.addTarget(self, action: #selector(buttonRightAction), for: .touchUpInside)
        }
        
        if underLineView == nil {
            
            underLineView = setupBaseView()
        }
        
        setupButtonConstraint()
        setupUnderLineViewConstraint()
    }
    
    private func setupUnderLineViewConstraint() {
        
        underLineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        underLineView.widthAnchor.constraint(equalTo: buttonLeft.widthAnchor).isActive = true
        underLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        underLineView.frame.origin.x = frame.minX
    }
    
    private func setupButtonConstraint() {
        
        setupButtonLeftConstraint()
        setupButtonCenterConstraint()
        setupButtonRightConstraint()
    }
    
    private func setupButtonLeftConstraint() {
        
        buttonLeft.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        setupTopBottomConstraint(button: buttonLeft)
        buttonLeft.trailingAnchor.constraint(equalTo: buttonCenter.leadingAnchor).isActive = true
        buttonLeft.widthAnchor.constraint(equalTo: buttonCenter.widthAnchor, multiplier: 1).isActive = true
        buttonLeft.widthAnchor.constraint(equalTo: buttonRight.widthAnchor, multiplier: 1).isActive = true
    }
    
    private func setupButtonCenterConstraint() {
        
        setupTopBottomConstraint(button: buttonCenter)
        buttonCenter.trailingAnchor.constraint(equalTo: buttonRight.leadingAnchor).isActive = true
    }
    
    private func setupButtonRightConstraint() {
        
        setupTopBottomConstraint(button: buttonRight)
        buttonRight.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func setupTopBottomConstraint(button: UIButton) {
        
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func setupBaseView() -> UIView {
        
        let view = UIView()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.playBandColorEnd
        return view
    }
    
    private func setupBaseButton() -> UIButton {
        
        let button = UIButton()
        
        self.addSubview(button)
        button.setTitleColor(UIColor.playBandColorEnd, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitle("Base", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupTitle(first: String, second: String, third: String) {
        
        buttonLeft.setTitle(first, for: .normal)
        buttonCenter.setTitle(second, for: .normal)
        buttonRight.setTitle(third, for: .normal)
    }
    
    func moveUnderLine(xPoint: CGFloat) {
        
        underLineView.frame.origin.x = xPoint
    }
    
    @objc func buttonLeftAction() {
        delegate?.leftAction()
    }
    
    @objc func buttonCenterAction() {
        delegate?.centerAction()
    }
    
    @objc func buttonRightAction() {
        delegate?.rightAction()
    }
    
}

protocol ThreeActionDelegate: class {
    
    func leftAction()
    func rightAction()
    func centerAction()
}
