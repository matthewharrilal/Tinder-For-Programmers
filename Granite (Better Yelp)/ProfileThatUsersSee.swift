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

class ProfileThatUsersSee: UIViewController {
    var username: String?
    var githubLink: String?
    var compLanguage: String?
    var hardCodedUsers: HardCodedUsers?
    var refHandle: UInt!
    // When it says that your class needs initalizers you can just make the property optional therefore you dont have to initalize the property for future references to come
    var databaseRef = Database.database().reference()
    var storageRef = Storage.storage().reference()
    @IBOutlet weak var computerLanguageLabel: UILabel!
    @IBOutlet weak var githubLinkLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //     updateChildValues()
           }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = self.username
        computerLanguageLabel.text = compLanguage
        githubLinkLabel.text = githubLink
        //        githubLinkLabel.text = self.githubLink
        //        computerLanguageLabel.text = self.compLanguage
        // So the reason this is working is because we are just passing the data from one view controller to another where as for the rest of the data showing up when a user taps the other users profile to see their credentials we are grabbing that from firebase database
        // Therefore the next course of action is to grab thej data to populate the labels with data from firebase
        //  setupProfile()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
//    func fetchUsers() {
//    refHandle = databaseRef.child("users").child()observe(.childChanged, with: { (snapshot) in
//        guard
//    })
//    }
    }
