//
//  CreateUsername.swift
//  Granite (Better Yelp)
//
//  Created by Matthew on 7/28/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class CreateUsername: UIViewController {
    
    // Declaration of the database reference
    let databaseRef  = Database.database().reference(fromURL: "https://granite3-dbd3a.firebaseio.com")
    // Outlets
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var agreementTextField: UITextField!
    
    @IBOutlet weak var compLanguageLabel: UILabel!
    @IBOutlet weak var githubName: UITextField!
    
    
    
    
    // Actions
    @IBAction func createAccount(_ sender: UIButton) {
        // signUp()
        //
        //        if fullName.text != "" {
        //
        //
        //        } else{
        //            textFieldIsEmpty()
        //        }
        //
        //        if emailTextField.text != "" {
        //
        //        }
        //        else{
        //            textFieldIsEmpty()
        //        }
        //        if usernameTextField.text != "" {
        //
        //        }else {
        //            textFieldIsEmpty()
        //        }
        //        if passwordTextField.text != "" {
        //
        //        }
        //        else{
        //            textFieldIsEmpty()
        //
        //        }
        // This creates creates the user in the firebase authentication
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if let error = error {
                  self.signUpErrors(error: error, controller: self)
                print(error.localizedDescription)
                //  AuthenticationUserServices.signUpErrors0(error: error, controller: self)
              
                
                // So essentially what we are doing here is that we are saying if the error is existent then show us the signup error but the problem we were having was that when we were saying that if the error does not exist becuase that was the only time we can actually work but the user returns nil but therefore it hits both the if and else statement
                return
            } else {
                
                // This creates the user inside the database
                UserService.create(self.usernameTextField.text!, self.emailTextField.text!, self.fullName.text!, self.passwordTextField.text!, self.githubName.text!, "", "", completion: { (user) in
                    guard let user = user
                        else{
                            
                            return
                            // But if the error is non existent we are going to create the user in the database
                    }
                })
                
            }
        }
        
        
        
        if agreementTextField.text == "Yes" || agreementTextField.text == "yes"   {
            
            
        }
        else{
            print("This statement is being printed because the user did not subjugate to the agreement of consent correctly")
            textFieldIsEmpty()
            
        }
        
        // Why is this function being called even if the text matches the exact same syntax as the one we want we have to research how to dismiss these notifications later
        
        // The reason their is only one alert kind for both actions is becuase i dont think you can asssign two alerts to one button
        
        // If they say no to the consent agreement they can not have access to the application
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldIsEmpty() {
        let ifTextFieldIsEmpty = UIAlertController(title: "Missing required text fields", message: "Please double check the text fields and see if you have entered them correctly and in addition no individual is permitted to use this app unless they have consent from a guardian or is over the age of 18", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Im Sorry", style: .default, handler: nil)
        ifTextFieldIsEmpty.addAction(cancelAction)
        self.present(ifTextFieldIsEmpty, animated: true, completion: nil)
    }
    
    func signUpErrors(error: Error, controller: UIViewController) {
        if emailTextField.text == "" || passwordTextField.text == "" || fullName.text == "" || usernameTextField.text == "" || agreementTextField.text != "yes" || agreementTextField.text == "Yes"{
            let wrongMove = UIAlertController(title: "Missing Input", message: "Please check the required text fields to make sure everything is satisfied", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
            wrongMove.addAction(cancelAction)
            self.present(wrongMove, animated: true, completion: nil)
        } else {
            switch(error.localizedDescription) {
            case "The email address is badly formatted.":
                let invalidEmailAlert = UIAlertController(title: "This email address is badly formatted", message: "Please try again with a different and correctly formatted email address", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                invalidEmailAlert.addAction(cancelAction)
                self.present(invalidEmailAlert, animated: true, completion: nil)
                break;
            default:
                let signUpErrorAlert = UIAlertController(title: "Trouble Signing You Up", message: "Please try creating an account at a later and more convient time", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                signUpErrorAlert.addAction(cancelAction)
                self.present(signUpErrorAlert, animated: true, completion:  nil)
                
                
            }
        }
        
    }
    
    //    func signUp() {
    //        guard let fullName = fullName.text
    //            else {
    //                print("full name errror")
    //                return
    //        }
    //        guard let email = emailTextField.text
    //            else {
    //                print("email issue")
    //                return
    //        }
    //        guard let username = usernameTextField.text
    //            else{
    //                print("username issue")
    //                return
    //        }
    //        guard let password = passwordTextField.text
    //            else{
    //                print("password issue")
    //                return
    //        }
    //        // The verifcation of new users
    //        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
    //            if error != nil {
    //                print(error)
    //                return
    //            }
    //            // We have to give each new user that is being made a specific user identification and why we dont put this code in the log in function is because if they are able to log in that means they already have a unique user identification
    //            // and of course we know  uid is for firebase
    //            guard let uid = user?.uid // Here we are essentially casting their user uid as a string
    //                else {
    //                    print("user uid issue")
    //                    return
    //            }
    //            let userReference = self.databaseRef.child("users").child(uid)
    //            // We are essentailly holding the users user identification here
    //            let values = ["username": username, "email": email, "password": password, "fullName": fullName]
    //            // What we are essentially doing here is that we are creating these keys to hold these specific users information so for example we are creating a key to contain all our
    //            userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
    //                if error != nil {
    //                    print("error updating child values")
    //                    print(error)
    //                    return
    //                }
    //                self.dismiss(animated: true, completion: nil)
    //            })
    //        }
    //        
    //    }
    
    
}
