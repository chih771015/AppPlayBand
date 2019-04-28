//
//  JGProgressHUD.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/28.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import JGProgressHUD

class PBProgressHUD {
    
    static let shared = PBProgressHUD()
    
    let loadingView: JGProgressHUD = {
        
        let view = JGProgressHUD(style: .dark)
        view.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        view.textLabel.text = "Loading"
        return view
    }()
    
    var view: UIView {
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return UIView() }
        guard let view = appdelegate.window?.rootViewController?.view else {
            return UIView()
        }
        return view
    }
    
    private init() {}
    
    static func addLoadingView(at view: UIView?, animated: Bool) {
        
        guard let view = view else {return}
        PBProgressHUD.shared.loadingView.show(in: view, animated: animated)
    }
    
    static func addLoadingView(animated: Bool) {
    
        PBProgressHUD.shared.loadingView.show(in: PBProgressHUD.shared.view, animated: animated)
    }
    
    static func dismissLoadingView(animated: Bool) {
        
        PBProgressHUD.shared.loadingView.dismiss(animated: animated)
    }
}
