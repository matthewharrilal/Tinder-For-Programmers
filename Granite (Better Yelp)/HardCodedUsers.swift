//
//  HardCodeduSERS.swift
//  Granite (Better Yelp)
//
//  Created by Matthew on 7/25/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseDatabase
import FirebaseAuth
import Kingfisher
class HardCodedUsers: NSObject {
    var username: String
    var email: String
    var fullName: String
    var password: String
    var githubName: String
    var githubLink: String?
    var computerLanguage: String?
    var userBio: String?
    var profilePic: String?
    
    // The reason we are making this optional is for the reason is because we know that the users dont need these values to make their account they add it later once they make it their account and the reason we can put this in a separate file is because it will be out of range because since we are passing the data from table view cell to the next view controller we would pass this in
    
    init(username: String, email:String, fullName: String, password:String, githubName: String, computerLanguage: String, githubLink: String, userBio: String,profilePic: String) {
        self.username = username
        self.email = email
        self.fullName = fullName
        self.password = password
        self.githubName = githubName
        self.computerLanguage = computerLanguage
        self.githubLink = githubLink
        self.userBio = userBio
        self.profilePic = profilePic
        
        // THIS IS USED FOR CREATINGGGGGGGGGGGGGGGGG therefore we wouldnt add the github link and the computer language here because since it is used for creating we dont want the users creation of their account whether or not they have a github link they add that later therefore we wouldnt add it in creating so we can add that when we are actually fetching that from the database
        
        // So we already know that we use initializers as the blueprints for instances to come of the class so essentially what we are doing right now is that we have to set the argument label username equal to the property username we have created for the class so basically what we are doing is that every instance that comes as a result of this class is going tobe initalized with this username argument label that is of type string and we can pass in any string which will corespond to the users unique username not to be confused with their uid
    }
    
    // Our initalizer that grabs the data from firebase and stores it locally essentially giving us our user defaults
    init?(snapshot: DataSnapshot) {
        // You are probably wondering if we are creating pathways to our firebase dictionary keys and values then where are we actually creating the reference to grab this data and to that I say DataSnapshot is a method from firebase that already comes with it so that in itself represents the pathway to firebase
        
        //And the reason we have to make a new initializer is because if we dont then it is going to have us work off the original initalizer we have and the reason we do not want that is because that original initalizer as we know sets the blueprints of all our other instances in addition to that the stuff we are initalizing in the has nothing to do with the data from firebase where as this we are actually retrieving the data from firebase through taking a snapshot
        guard let dict = snapshot.value as? [String:Any],
            let username = dict["username"] as? String,
            let email = dict["email"] as? String,
            let fullName = dict["fullName"] as? String,
            let password = dict["password"] as? String,
            let githubName = dict["githubName"] as? String,
            let githubLink = dict["githubLink"] as? String,
            let compLanguage = dict["compLanguage"] as? String,
            let userBio = dict["userBio"] as? String,
            let profilePic = dict["pic"] as? String
        
            // THIS IS FOR FETCHINGGGGGGGG
            else {
                return nil
        }
        // The reason we are initializing all this data as oppose to just email and password the credentials needed for the users to log in is because we want all this data to be stored locally
        self.username = username
        self.password = password
        self.fullName = fullName
        self.email = email
        self.githubName = githubName
        self.githubLink = githubLink
        self.computerLanguage = compLanguage
        self.userBio = userBio
        self.profilePic = profilePic
              
        // The reason we do this is becuase we are essentially setting our properties of the users equal to the initalizers we are placing on the users who are coming into existence
        
    }
    
    //So essentially what we are going to be doing next is what we call boilerplate code and what that essentially means is that that is code that is called multiple times with little or no alteration but ends up being neccessary and this is very good sometimes because it can give a developer more direct control over their code meaning if thney have more control over specific migrations in their code that may occur and so if they want a different thing happening somewhere they can implement that
    
    required init?(coder aDecoder: NSCoder) {
        guard let username = aDecoder.decodeObject(forKey: "username") as? String,
            let email = aDecoder.decodeObject(forKey: "email") as? String,
            let password = aDecoder.decodeObject(forKey: "password") as? String,
            let fullName = aDecoder.decodeObject(forKey: "fullName") as? String,
            let githubName = aDecoder.decodeObject(forKey: "githubName") as? String
               else{return nil}
        // So essentially what is happening here is that we are now decoding the data we are getting from firebase and you are probably wondering why we are doing this when we just observed the data snapshot and are returning that data as well as casting it as a string and what is essentially happening here is as we know initializers are blueprints that are setup for future instances and what we are doing here is that we are decoding this data from firebase for each instance that is made and we know that each instance that is made is a new user therefore we have to decode the data that we are going to be saving locally
        self.username  = username
        self.email = email
        self.fullName = fullName
        self.password = password
        self.githubName = githubName
        
        super.init()
        
        
        
    }
    
    
    
    // now lets not forget to implement data in a database we have to make a dictionary where the key would be what we type to retireve the data for that key
    // We are constructing a dictionary right now
    var dictValue: [String: Any] {
        return["username": username, "email": email, "fullName": fullName, "password": password, "githubName": githubName, "githubLink": githubLink, "compLanguage": computerLanguage, "userBio": userBio]
        // So what is essentially happening here is that we are passing in the string username into the class poroperty called username and what this essentially does is that like we said earlier that every instance is initialized with the propery username meaning that every user has a username so basically what we are doing right now is that for every username value or the string they chsoose to be their username we are assigning it to the key "username"
        
        // Juat a side noe the reason we dont need a failable initializer is because we have no use for user anonymous functionality
        
        
        
    }
    // Right now we have to create a user Singleton for the logged out user
    private static var _current: HardCodedUsers?
    static var current: HardCodedUsers {
        guard let currentUser = _current else {
            
            fatalError("Error: current user doesn't exist")
        }
        return currentUser
    }
    
    
    
    // Right here we are going to initalize our data snapshot
    class func setCurrent(_ user: HardCodedUsers, writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            UserDefaults.standard.set(data, forKey: "currentUser")
            UserDefaults.standard.synchronize()
            
        }
        _current = user
    }
}

extension HardCodedUsers: NSCoding {
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(username, forKey: "username")
        aCoder.encode(password, forKey: "password")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(fullName, forKey: "fullName")
        aCoder.encode(githubName, forKey: "githubName")
          }
    // So let us talk about what is happening here and lets differentiate the difference between nscoder and nscoding so first off nscoder and what it essentially does  is that it lets us transfer objects made in our code through memory and through differrent subclasses whiles NSCoding what that essentially does is that it implements two methods that your class must use which is to encode and decode meaning we can encode the data we get from firebase  as well as decode it locally basically giving as an entry as well as a secure departure
    // this part of the code what we are essentially doing is that we are encoding the data we have for each of the properties of the users and we encode it locally
}


