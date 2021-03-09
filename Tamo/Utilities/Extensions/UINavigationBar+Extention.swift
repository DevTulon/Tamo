//
//  UINavigationBar+Extention.swift
//  Tamo
//
//  Created by Reashed Tulon on 8/3/21.
//

import Foundation
import UIKit

extension UINavigationBar {
    func shouldRemoveShadow(_ value: Bool) -> Void {
        if value {
            self.setValue(true, forKey: "hidesShadow")
        } else {
            self.setValue(false, forKey: "hidesShadow")
        }
    }
}
