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
    
  
    
    var hardCodedUser: HardCodedUsers?
    
    
    var refHandle: UInt!
    var profileImageURL:String?
    var objectUser: HardCodedUsers?
    @IBOutlet weak var profilePic: UIImageView!
    
    // Let us create an object for our class
    
    
    // When it says that your class needs initalizers you can just make the property optional therefore you dont have to initalize the property for future references to come
    var databaseRef = Database.database().reference()
   
    @IBOutlet weak var computerLanguageLabel: UILabel!
    @IBOutlet weak var githubLinkLabel: UILabel!
    @IBOutlet weak var userBioLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    
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
        
let user = self.objectUser
        UserService.show(forUID: (user?.username)!, completion: {(user) in
            guard let user = user else {
            return
            }
            self.usernameLabel.text = user.username
            self.githubLinkLabel.text = user.githubLink
            self.computerLanguageLabel.text = user.computerLanguage
            self.userBioLabel.text = user.userBio
            // So essentially what this user service .show function does is that is displays the data for the authenticated user and we have to decide what part of that data we actually want
            
        })
        
//        usernameLabel.text = user?.username
//        userBioLabel.text = user?.userBio
//        githubLinkLabel.text = user?.githubLink
//        computerLanguageLabel.text = user?.computerLanguage
//        databaseRef.child("users").observeSingleEvent(of: .childAdded, with: { (snapshot) in
//            if let dict = snapshot.value as? [String: Any] {
//                if let profileImageURL = user?.pic {
//                let url = URL(string: profileImageURL)
//                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//                        if error != nil {
//                        print(error?.localizedDescription)
//                            return
//                        }
//                        DispatchQueue.main.async {
//                            self.profilePic.image = UIImage(data: data!)
//                        }
//                    }).resume()
//                }
//            }
//        })
//        
     
    }
    //
    func removeAuthListener (authHandle: AuthStateDidChangeListenerHandle?)
    {
        if let authHandle = authHandle{
            
            Auth.auth().removeStateDidChangeListener(authHandle)
            
        }
        // So as we know what is happening is that what a handler does is that creates and returns an action with the specified behavior so what this does is almost like a setting function because what we are essentially doing is that we are changing the code within firebase to say change the listener block to a block that essentailly tells us that the user has signed out
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
