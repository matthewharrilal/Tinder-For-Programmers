//
//  AuthenticationServices.swift
//  Granite (Better Yelp)
//
//  Created by Matthew on 8/5/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuthUI
import Alamofire
import UIKit
import FirebaseAuth
typealias FIRUser = FirebaseAuth.User
struct AuthenticationUserServices {
// Handles the login errors as well the sign up errors that may occur
    
     func logInErrors(error: Error, controller: UIViewController) {
        switch(error.localizedDescription) {
      case "The email address is badly formatted.":
        let invalidEmailAlert = UIAlertController(title: "Invalid Email", message: "This email account does not exist, please try again", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
        invalidEmailAlert.addAction(cancelAction)
        controller.present(invalidEmailAlert, animated:  true, completion:  nil)
        
        case "The password is invalid or the user does not have a password.":
            let wrongPasswordAlert = UIAlertController(title: "Wrong Password", message:
                "It seems like you have entered the wrong password.", preferredStyle: UIAlertControllerStyle.alert)
            wrongPasswordAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            controller.present(wrongPasswordAlert, animated: true, completion: nil)
            break;
        case "There is no user record corresponding to this identifier. The user may have been deleted.":
            let wrongPasswordAlert = UIAlertController(title: "No Account Found", message:
                "We couldn't find an account that corresponds to that email. Do you want to create an account?", preferredStyle: UIAlertControllerStyle.alert)
            wrongPasswordAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            controller.present(wrongPasswordAlert, animated: true, completion: nil)
            break;
        default:
            let loginFailedAlert = UIAlertController(title: "Error Logging In", message:
                "There was an error logging you in. Please try again soon.", preferredStyle: UIAlertControllerStyle.alert)
            loginFailedAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            controller.present(loginFailedAlert, animated: true, completion: nil)
            break;
        }
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
    
    static func determineUsernameAvailability(usernameToBeDetermined : String, completion : @escaping (Bool) -> Void ) {
        var isAvailable : Bool = true
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userSnapshotArray = snapshot.children.allObjects as? [DataSnapshot]
                else {print("Username not available")
                    return}
            
            for snapshotItem in userSnapshotArray {
                if let thisUser = HardCodedUsers(snapshot: snapshotItem){
                    if thisUser.username == usernameToBeDetermined {
                        isAvailable = false
                    }
                    
                    
                }
                
            }
            
            return completion(isAvailable)
        })
        
        
    }

    static func signUpErrors0(error: Error, controller: UIViewController) {
        switch(error.localizedDescription) {
        case "The email address is badly formatted.":
            let invalidEmail = UIAlertController(title: "Email is not properly formatted.", message:
                "Please enter a valid email to sign up with..", preferredStyle: UIAlertControllerStyle.alert)
            invalidEmail.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            controller.present(invalidEmail, animated: true, completion: nil)
            break;
            
            case "The password must be 6 characters long or more.":
                let shortPassword = UIAlertController(title: "Password is too short", message: "Please use a different password that is longer", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                shortPassword.addAction(cancelAction)
            controller.present(shortPassword, animated: true, completion: nil)
                break;
        default:
            let generalErrorAlert = UIAlertController(title: "We are having trouble signing you up.", message:
                "We are having trouble signing you up, please try again soon.", preferredStyle: UIAlertControllerStyle.alert)
            generalErrorAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            controller.present(generalErrorAlert, animated: true, completion: nil)
            break;
        }
    }
    
        }
    




