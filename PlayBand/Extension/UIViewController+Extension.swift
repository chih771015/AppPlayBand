//
//  UIViewController+Extension.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/27.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addErrorAlertMessage(
        title: String?  = FirebaseEnum.fail.rawValue, message: String?,
        completionHanderInDismiss: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            
            guard let completionHander = completionHanderInDismiss else {return}
            completionHander()
        }
        alertAction.setupActionColor()
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    func addErrorTypeAlertMessage(
        title: String? = FirebaseEnum.fail.rawValue,
        error: Error?, completionHanderInDismiss: (() -> Void)? = nil) {
        
        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            
            completionHanderInDismiss?()
        }
        
        alertAction.setupActionColor()
        
        if let inputError = error as? InputError {
            
            let alert = UIAlertController(
                title: title, message: inputError.localizedDescription, preferredStyle: .alert)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)

        } else {
            
            let alert = UIAlertController(title: title, message: error?.localizedDescription, preferredStyle: .alert)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
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
    
    func addTextFieldAlert(
        title: String? = nil, message: String? = nil, actionTitle: String? = nil, cancelTitle: String? = nil,
        placeHolder: String? = nil, keyboardType: UIKeyboardType = UIKeyboardType.default,
        cancelHandler: ((UIAlertAction) -> Void)? = nil, actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = placeHolder
            textField.keyboardType = keyboardType
        }
        
        let action = UIAlertAction(title: actionTitle, style: .default, handler: { _ in
            
            guard let textField = alert.textFields?.first else {
                
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        })
        
        action.setupActionColor()
        
        let cancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler)
        cancel.setupActionColor()
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func addAlert(
        title: String? = nil, message: String? = nil, actionTitle: String? = nil, cancelTitle: String? = nil,
        cancelHandler: ((UIAlertAction) -> Void)? = nil, actionHandler: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: actionTitle, style: .default, handler: actionHandler)
        
        let cancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler)
        action.setupActionColor()
        cancel.setupActionColor()
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    static func returnLoginPage() {
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let loginVC = UIStoryboard.signIn.instantiateInitialViewController()
        appdelegate.window?.rootViewController = loginVC
    }
}
