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
    var userBio: String?
    var hardCodedUsers: HardCodedUsers?
    var refHandle: UInt!
    // When it says that your class needs initalizers you can just make the property optional therefore you dont have to initalize the property for future references to come
    var databaseRef = Database.database().reference()
    var storageRef = Storage.storage().reference()
    @IBOutlet weak var computerLanguageLabel: UILabel!
    @IBOutlet weak var githubLinkLabel: UILabel!
    @IBOutlet weak var userBioLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = self.username
        computerLanguageLabel.text = compLanguage
        githubLinkLabel.text = githubLink
        userBioLabel.text = userBio
            // So esssentially what we are doing here is that we are setting the text of each of these labels in our view controller equal to the optional variables of this view controller
            
        // As we know the optional variables hold the data of our nodes from our fireabase database therefore we are succesfully populating these lables text dynamically
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
