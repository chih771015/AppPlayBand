//
//  UIViewController+Extension.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/27.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

typealias ActionHandler = (String, ((UIAlertAction) -> Void)?)

extension UIViewController {
    
    func addErrorAlertMessage(
        title: String?  = FirebaseEnum.fail.rawValue, message: String?,
        completionHanderInDismiss: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let alertAction = UIAlertAction(title: "OK", style: .default, handler: completionHanderInDismiss)
        alertAction.setupActionColor()
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    func addErrorTypeAlertMessage(
        title: String? = FirebaseEnum.fail.rawValue,
        error: Error?, completionHanderInDismiss: ((UIAlertAction) -> Void)? = nil) {
        
        addErrorAlertMessage(title: title, message: error?.localizedDescription, completionHanderInDismiss: completionHanderInDismiss)
    
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
    
    func addAlertActionSheet(title: String? = nil, message: String? = nil, actionTitleAndHandlers: [ActionHandler], cancelTitle: String, cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        
        if actionTitleAndHandlers.isEmpty {
            
            addErrorAlertMessage(message: "沒有輸入按鈕\n有Bug")
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for action in actionTitleAndHandlers {
            
            let title = action.0
            let actionManger = UIAlertAction(title: title, style: .default, handler: action.1)
            actionManger.setupActionColor()
            alert.addAction(actionManger)
        }
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler)
        cancelAction.setupActionColor()
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

}
