//
//  Extensions.swift
//  Granite (Better Yelp)
//
//  Created by Matthew Harrilal on 8/19/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuthUI

let imageCache = NSCache<AnyObject, AnyObject>()
// This imageCache let constant will serve as the memory bank for all our downloaded photos from firebase storage


extension UIImageView {
    
    func loadImageUsingCacheWithURLString(urlString: String) {
        
        // check cache if the desired image exists within the cache
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
         self.image = cachedImage
            return
        }
        //otherwize iniatiate a new download from firebase database
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!) {
                    
                self.image = downloadedImage
                
                }
            }
        }).resume()
    }
    
        
}
