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
        // This creates creates the user in the firebase authentication
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if let error = error {
                self.signUpErrors(error: error, controller: self)
                print(error.localizedDescription)
                
                
                
                // So essentially what we are doing here is that we are saying if the error is existent then show us the signup error but the problem we were having was that when we were saying that if the error does not exist becuase that was the only time we can actually work but the user returns nil but therefore it hits both the if and else statement
                return
            } else {
                
                // This creates the user inside the database
                UserService.create("", "", self.usernameTextField.text!, self.emailTextField.text!, self.fullName.text!, self.passwordTextField.text!,self.githubName.text!, "", "",completion: { (user) in
                    // The reason we are using empty strings to satisfy the following initalizers: githubLink as compLAnguage as well as userBio is because as we know since we are adding them to our initalizer to create user as well as access them from any file we would have to call them in this call of our userService struct but they do not need to add that when they create their account therefore to satisfy the empty strings then the user later updates them as they customize their profile
                    print(self.passwordTextField.text)
                    print(self.githubName.text)
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
    
}
