//
//  UIImage+Extention.swift
//  Tamo
//
//  Created by Reashed Tulon on 8/3/21.
//

import UIKit

extension UIImage {
    func resizeImage(to size: CGSize) -> UIImage {
       return UIGraphicsImageRenderer(size: size).image { _ in
           draw(in: CGRect(origin: .zero, size: size))
    }
}}
