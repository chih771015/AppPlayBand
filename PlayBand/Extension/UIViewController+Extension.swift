//
//  UIViewController+Extension.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/27.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addErrorAlertMessage(title: String?, message: String?, completionHanderInDismiss: (() -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            
            guard let completionHander = completionHanderInDismiss else {return}
            completionHander()
        }
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    func addSucessAlertMessage(title: String?, message: String?, completionHanderInDismiss: (() -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        present(alert, animated: true) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                alert.dismiss(animated: true, completion: nil)
                guard let completionHander = completionHanderInDismiss else {return}
                completionHander()
            })
        }
    }
}
