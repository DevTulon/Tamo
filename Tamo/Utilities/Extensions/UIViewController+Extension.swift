//
//  UIViewController+Extension.swift
//  Somethingfishybd
//
//  Created by Reashed Tulon on 28/7/19.
//  Copyright © 2019 Apollo66. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    //MARK: For Storyboard Router
    func pushViewController(T: UIViewController) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(T, animated: true)
        }
    }
    
    func presentViewController(T: UIViewController) {
        DispatchQueue.main.async {
            self.present(T, animated: true, completion: nil)
        }
    }
    
    //MARK: For AlertView
    func popupAlert(title: String, message: String, actionTitles:[String], actionStyle: [UIAlertAction.Style], action:[((UIAlertAction) -> Void)]) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.view.tintColor = UIColor.defaultAppsColor
            for (index, title) in actionTitles.enumerated() {
                let action = UIAlertAction(title: title, style: actionStyle[index], handler: action[index])
                alert.addAction(action)
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func hideKeyboardWhenTapOnScreen () {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
