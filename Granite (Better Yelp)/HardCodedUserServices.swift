//
//  HardCodedUserServices.swift
//  Granite (Better Yelp)
//
//  Created by Matthew on 7/25/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuthUI
import Firebase
import FirebaseDatabase
import FirebaseAuth


struct UserService {
    static func create(_ githubLink: String, _ computerLanguage: String, _ username: String, _ email: String, _ fullName: String, _ password: String, _ githubName: String,_ userBio: String,completion: @escaping(HardCodedUsers?) -> Void) {
        let user = HardCodedUsers(username: username, email: email , fullName: fullName, password: password, githubName: githubName, computerLanguage: computerLanguage, githubLink: githubLink, userBio: userBio)
        // We are making an object of our HardCodedUsersClass
        let dict = user.dictValue
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(uid!)
        // What this oneline of code above this essentially does is that it lets us give the user in the database a unique identification
        
        ref.setValue(dict) { (error,ref) in
            if let error = error {
            assertionFailure(error.localizedDescription)
                return completion(nil)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let user = HardCodedUsers(snapshot:snapshot)
                    completion(user)
                })
            }
            }
            
        //So lets go over these lines of code and what they essentially do, so basically we are declaring a private static func and first and foremost we could have done this many ways but we decided to go wit the most security because this would hold our usernames and their credentials in our firebase database, so essentially what we are doing here is that we want this static function which means it cant be overwritten and we call this function create and the parameters this function create contains the null argument label called username and this is of type string then in the next line of code is that we declare a let constant called dict and it holds the dictionary that holds the values for the key usernames and the reason why we did this is something we will address shortly 
        
        // in the next line of code what we essentially do is that we have this let constant called ref and what this essentially does is that it holds the pathway or the reference we made to the place in our firebase database that holds the data for the users usernames and as we know since now we have access to the usernames of the users lets say we have a million user we are not going to scroll all day trying to find an indivdual user so by making another child of the child usernames of users we have this property called child by auto id and what this essentially does is that it lets us give each user with a username a specific user identification which differs from there username 
        
        // Now in the last line of code what we are essentially doing is that we are taking the let constant we declared earlier, ref, and using the set value property which what that does is that it basically writes  to the database fire base location but it doesnt know what to write so remember how we would address why we would create a let constant that basically holds all the dictionary data well this is where we use it so we pass in that data so it know what to write in the firebase location, but you are still probably wondering even though it knows what to write how does it know where to write so the reason we put ref behind this set vle is becuase the let constant holds the pathway to the usernames of users database so thats how it knows where to  write it becuase we are literlaly taking it along the pathway of where we want it to write to 
    }
    
    static func createUser(controller: UIViewController, email: String, password: String, completion: @escaping (FIRUser)-> Void) {
    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
        if let error = error {
            signUpErrors0(error: error, controller: controller)
           return 
        }
        return completion(Auth.auth().currentUser!)
        }
    }
    // To get all the users in the table view cells except for the current user logged in the table view cells
    static func usersExcludingCurrentUser(completion: @escaping([HardCodedUsers])-> Void) {
        let currentUser = HardCodedUsers.current
        // What this essentially means is that we are creating this new let constant called currentUser and setting it equal to the current user in the hard coded users array
        
        // Secondly we are creating a database reference to read and iterate over the users from our database
        let databaseReference = Database.database().reference().child("users")
        // And the reason we dont add another child is becauase if we add the child of the uid is because we would be reading from the current users credentials where as where we stop at the child "users" we would be reading from all our users in our database
        
        // Observing and taking a snapshot of the users within our database
        databaseReference.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else {return completion([])}
            let uid = Auth.auth().currentUser
            //let users = snapshot.flatMap(HardCodedUsers.init).filter { $0.uid != currentUser.username }
        })
    // So essentially what we are doing here is that we are getting a snapshot from firebase as we are observing the data and if we cant observe we will just return the array of users at least thats what I am thinking is happening
        
        // Take a snapshot and make a few transformations and what I believe that means is that since we are embedded in the data at the database withing our firebase we have to now filter the current user out 
        
    }
    
    static func observeProfile(for user: HardCodedUsers, completion: @escaping(DatabaseReference, HardCodedUsers?) -> Void )-> DatabaseHandle {
        let uid = Auth.auth().currentUser?.uid
    let userRef = Database.database().reference().child("users").child(uid!)
        return userRef.observe(.value, with: { snapshot in
            guard let user = HardCodedUsers(snapshot: snapshot) else {
                return completion(userRef, nil)
            }
            completion(userRef, user)
        })
        // So essentially what we are doing here is that we are observing the users profiles for any changes that are being made and by using the completion handler with the @escaping it has happening asynchronously as well as listening constantly for any changes
    }
    
    
    // The reason we are not making this private in the first place is becuause we are going to call it later so in a sense we want it public
    static func show(forUID uid: String, completion: @escaping(HardCodedUsers?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = HardCodedUsers(snapshot: snapshot) else{
                // The reason it is giving us this error up above is because we never initialized the data snapshot therefore it is going off of our original initalizer 
                return completion(nil)
                
            }
            completion(user)
        })
    }
    
    
   private static func signUpErrors0(error: Error, controller: UIViewController) {
        switch (error.localizedDescription) {
            //        case "The email address is badly formatted.":
            //            let invalidEmailAlert = UIAlertController(title: "This email address is badly formatted", message: "Please try again with a different and correctly formatted email address", preferredStyle: .alert)
            //            let cancelAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            //            invalidEmailAlert.addAction(cancelAction)
            //            controller.present(invalidEmailAlert, animated: true, completion: nil)
        //            break;
        default:
            let signUpErrorAlert = UIAlertController(title: "Trouble Signing You Up", message: "Please try creating an account at a later and more convient time", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            signUpErrorAlert.addAction(cancelAction)
            controller.present(signUpErrorAlert, animated: true, completion:  nil)
            
            
        }
        
    }
    
}
