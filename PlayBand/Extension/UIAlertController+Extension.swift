//
//  UIAlertController+Extension.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/15.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

//extension UIAlertController {
//    
//    class func alertMessageAnimation(title: String?, message: String?, viewController: UIViewController?, completionHanderInDismiss: (() -> Void)?) {
//        
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        
//        guard viewController != nil else {
//            
//            return
//        }
//        viewController?.present(alert, animated: true) {
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//                alert.dismiss(animated: true, completion: nil)
//                guard let completionHander = completionHanderInDismiss else {return}
//                completionHander()
//            })
//        }
//    }
//}
