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

extension UIImageView {
      func loadImageUsingCacheWithURLString(urlString: String) {
        Database.database().reference().child("users").observeSingleEvent(of: .childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                if let profileImageURL = dict["pic"] as? String {
                    let url = URL(string: urlString)
                    URLSession.shared
                        .dataTask(with: url!, completionHandler: { (data, response, error) in
                            if error != nil {
                                print("The agent has reached the destination")
                                print(error?.localizedDescription)
                                return
                            }
                            DispatchQueue.main.async {
                                self.image = UIImage(data: data!)
                            }
                        }).resume()
                }
            }
        })

    }
}
