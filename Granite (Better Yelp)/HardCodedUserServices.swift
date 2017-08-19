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
    // So essentially what is happening in our code here is that we need this to be used to set the data for users in  our firebase database and what that means is when are creating the user in our database by using the code in our model class that is creating it yes, but it is not setting the values and the reason we want to set the values is for a multitude of reasons such as what if the user logs out and wants to log back in they have no credentials to log back in with therefore they will have to create a new account and then the same error will continue to occur 
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
//    static func usersExcludingCurrentUser(completion: @escaping([HardCodedUsers])-> Void) {
//        let currentUser = HardCodedUsers.current
//        // What this essentially means is that we are creating this new let constant called currentUser and setting it equal to the current user in the hard coded users array
//        
//        // Secondly we are creating a database reference to read and iterate over the users from our database
//        let databaseReference = Database.database().reference().child("users")
//        // And the reason we dont add another child is becauase if we add the child of the uid is because we would be reading from the current users credentials where as where we stop at the child "users" we would be reading from all our users in our database
//        
//        // Observing and taking a snapshot of the users within our database
//        databaseReference.observeSingleEvent(of: .value, with: { (snapshot) in
//            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
//                else {return completion([])}
//            let uid = Auth.auth().currentUser
//            let users = snapshot.flatMap()
//            
//            // We are about to create a new dispatch group so that we can be notified when all asynchronous tasks are finished executing
//            let dispatchGroup = DispatchGroup()
//            
//            // Calls the given closure on each element in the sequence in the same order as a for in loop
//            users.forEach({(user) in
//            dispatchGroup.enter()
//                
//            })
//        })
//   
//    }
    
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
