//
//  ProfileThatUsersSee.swift
//  Granite (Better Yelp)
//
//  Created by Matthew on 8/2/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuthUI
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import Kingfisher
class ProfileThatUsersSee: UIViewController {
    var username: String?
    var githubLink: String?
    var compLanguage: String?
    var userBio: String?
    var hardCodedUsers: HardCodedUsers?
    var refHandle: UInt!
    var profileImageURL:String?
    var objectUser: HardCodedUsers?
    @IBOutlet weak var profilePic: UIImageView!
    
    // Let us create an object for our class
    
    
    // When it says that your class needs initalizers you can just make the property optional therefore you dont have to initalize the property for future references to come
    var databaseRef = Database.database().reference()
    var storageRef = Storage.storage().reference()
    @IBOutlet weak var computerLanguageLabel: UILabel!
    @IBOutlet weak var githubLinkLabel: UILabel!
    @IBOutlet weak var userBioLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if let profileImageURL = objectUser?.profilePic {
//            let url = URL(string: profileImageURL)
//            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//                if error != nil {
//                    print(error)
//                    return
//                }
//                DispatchQueue.main.async {
//                    self.profilePic.image = UIImage(data: data!)
//                }
//            }).resume()
//        }
        


    }
    
    @IBAction func toWebBrowser(_ sender: UIButton) {
        openURL(url: githubLink)
    }
    func openURL(url: String!) {
        if let url = URL(string: url!) {
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
   

   
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = self.username
        computerLanguageLabel.text = compLanguage
        githubLinkLabel.text = githubLink
        userBioLabel.text = userBio
        databaseRef.child("users").observeSingleEvent(of: .childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                if let profileImageURL = dict["pic"] as? String {
                let url = URL(string: profileImageURL)
                    URLSession.shared
                    .dataTask(with: url!, completionHandler: { (data, response, error) in
                        if error != nil {
                            print("The agent has reached the destination")
                        print(error?.localizedDescription)
                            return
                        }
                        DispatchQueue.main.async {
                            self.profilePic.image = UIImage(data: data!)
                        }
                    }).resume()
                }
            }
        })
       
        

        
           }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
