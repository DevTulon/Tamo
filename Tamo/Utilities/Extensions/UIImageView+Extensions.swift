//
//  UIImageView+Extensions.swift
//  CountryPicker
//
//  Created by Reashed Tulon on 6/10/19.
//  Copyright © 2019 Reashed Tulon. All rights reserved.
//

import UIKit

var imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImageUsingCache(forURLString : String, withPlaceholderImageName: String, complition: @escaping (_ success: Bool)->Void) {
        let url = URL(string: forURLString)
        if url == nil {return}
        self.image = UIImage(named: withPlaceholderImageName)
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: forURLString as NSString)  {
            self.image = cachedImage
            complition(true)
        } else {
            // if not, download image from url
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                DispatchQueue.main.async {
                    if data != nil {
                        if let image = UIImage(data: data!) {
                            imageCache.setObject(image, forKey: forURLString as NSString)
                            self.image = image
                        }
                    } else {
                        self.image = UIImage(named: withPlaceholderImageName)
                    }
                    complition(true)
                }
            }).resume()
        }
    }
    
    func roundedImageView(borderWidth: CGFloat, cornerRadius: CGFloat, borderColor: UIColor) {
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = false
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    func blurImageView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        // for supporting device rotation
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        self.layoutIfNeeded()
    }
    
    func topRoundedImageView(cornerRadius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
