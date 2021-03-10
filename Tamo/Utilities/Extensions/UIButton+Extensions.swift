//
//  UIButton+Extensions.swift
//  FirebaseFeediOS
//
//  Created by Reashed Tulon on 7/7/20.
//  Copyright © 2020 Reashed Tulon. All rights reserved.
//

import UIKit

extension UIButton {
    func roundedButton(borderWidth: CGFloat, cornerRadius: CGFloat, borderColor: UIColor) {
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = false
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
}
