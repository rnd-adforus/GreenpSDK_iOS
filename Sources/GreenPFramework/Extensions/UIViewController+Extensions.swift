//
//  UIViewController+Extensions.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import UIKit

extension UIViewController {
    func alert(message: String, title: String = "", confirmTitle: String? = nil, confirmHandler: ((UIAlertAction) -> Void)? = nil, cancelTitle: String, cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler)
            alertController.addAction(cancel)
            if let confirmTitle = confirmTitle {
                let confirm = UIAlertAction(title: confirmTitle, style: .default, handler: confirmHandler)
                alertController.addAction(confirm)
            }
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
