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
//                databaseRef.child("users").observeSingleEvent(of: .childAdded, with: { (snapshot) in
//                    if let dict = snapshot.value as? [String: AnyObject] {
//                        if let profileImageURL = dict["pic"] as? String {
//                        let url = URL(string: profileImageURL)
//                            URLSession.shared
//                            .dataTask(with: url!, completionHandler: { (data, response, error) in
//                                if error != nil {
//                                    print("The agent has reached the destination")
//                                print("This has been a nil attempt")
//                                    return
//                                }
//                                DispatchQueue.main.async {
//                                    self.profilePic.image = UIImage(data: data!)
//                                }
//                            }).resume()
//                        }
//                    }
//                })
//        
        // This one grabs it once but doesnt even grab the right image and sets if for all the other users as the same wrong image
        

        
        databaseRef.child("users").observe(.childAdded, with: { (snapshot) in
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
        
        // So essentially what is happening here is that we are getting the picture but it changes from an outdated one and then takes us to the correct one but on the other hand it sets it the same for all users which is the problem we are trying to fix
    }
    
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
