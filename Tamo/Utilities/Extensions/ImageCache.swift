//
//  UIImage+Extension.swift
//  Somethingfishybd
//
//  Created by Reashed Tulon on 5/12/19.
//  Copyright © 2019 Apollo66. All rights reserved.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    private init() { }
    
    func getCachedImage(forURLString : String, withPlaceholderImageName: String, complition: @escaping (_ cImage: UIImage)->Void) {
        let url = URL(string: forURLString)
        if url == nil {return}

        var finalImage = UIImage(named: withPlaceholderImageName)
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: forURLString as NSString)  {
            finalImage = cachedImage
            complition(finalImage!)
        } else {
            // if not, download image from url
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                DispatchQueue.main.async {
                    if data != nil {
                        if let image = UIImage(data: data!) {
                            imageCache.setObject(image, forKey: forURLString as NSString)
                            finalImage = image
                        }
                    } else {
                        finalImage = UIImage(named: withPlaceholderImageName)
                    }
                    complition(finalImage!)
                }
            }).resume()
        }
    }
}
