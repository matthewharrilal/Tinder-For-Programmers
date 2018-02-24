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
 import SystemConfiguration
 import KeychainSwift
 
 
 class CreateUsername: UIViewController {
    
    // Declaration of the database reference
    let databaseRef  = Database.database().reference(fromURL: "https://granite3-dbd3a.firebaseio.com")
    var usernameIsAvailbale: Bool = true
    // Outlets
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var agreementTextField: UITextField!
    
    @IBOutlet weak var compLanguageLabel: UILabel!
    @IBOutlet weak var githubName: UITextField!
    var user: HardCodedUsers?
    
    
    // Actions
    @IBAction func createAccount(_ sender: UIButton) {
        showAlert()
        var username = usernameTextField.text
        let keychain = KeychainSwift()
        
        let passwordCount = passwordTextField.text?.characters.count
        if passwordCount! < 6 {
            let passwordShort = UIAlertController(title: "Password too short", message: "Please enter a longer password", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
            passwordShort.addAction(cancelAction)
            self.present(passwordShort, animated: true,completion: nil)
            
        }
        
        // This creates creates the user in the firebase authentication
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if let error = error {
                self.signUpErrors(error: error)
                print(Auth.auth().currentUser)
                
                
                // So essentially what we are doing here is that we are saying if the error is existent then show us the signup error but the problem we were having was that when we were saying that if the error does not exist becuase that was the only time we can actually work but the user returns nil but therefore it hits both the if and else statement
                return
            } else {
                
                AuthenticationUserServices.determineUsernameAvailability(usernameToBeDetermined: username!){ (truth) in
                     let fullName = self.fullName.text! 
//                    keychain.set(fullName, forKey: "fullName")
                    self.usernameIsAvailbale = truth
                    if self.usernameIsAvailbale == true {
                        UserService.create("", "", self.usernameTextField.text!, self.emailTextField.text!, self.fullName.text!, self.passwordTextField.text!,self.githubName.text!, "", "", (user?.uid)!,completion: { (user) in
                            // The reason we are using empty strings to satisfy the following initalizers: githubLink as compLAnguage as well as userBio is because as we know since we are adding them to our initalizer to create user as well as access them from any file we would have to call them in this call of our userService struct but they do not need to add that when they create their account therefore to satisfy the empty strings then the user later updates them as they customize their profile
                            guard let user = user
                                else{
                                    
                                    return
                                    // But if the error is non existent we are going to create the user in the database
                            }
                            HardCodedUsers.setCurrent(user,writeToUserDefaults:  true)
                        })
                        
                                         }
                      
                    else {
                        let alert = UIAlertController(title: "Sorry", message: "This username is already taken, please choose another", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        print("this username is already taken fam")
                        
                    }
                      self.performSegue(withIdentifier: "toViewController", sender: self)

                    
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        showAlert()
    }
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func showAlert() {
        if !isInternetAvailable() {
            let alert = UIAlertController(title: "Warning", message: "The Internet is not available", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
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
    
    func signUpErrors(error: Error) {
        if emailTextField.text == "" || passwordTextField.text == "" || fullName.text == "" || usernameTextField.text == "" || agreementTextField.text != "yes" {
            let wrongMove = UIAlertController(title: "Missing Input", message: "Please check the required text fields to make sure everything is satisfied", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
            wrongMove.addAction(cancelAction)
            self.present(wrongMove, animated: true, completion: nil)
            return
        } else {
            
            if let errCode = AuthErrorCode(rawValue: error._code) {
                switch errCode {
                case .emailAlreadyInUse:
                    let emailInUse = UIAlertController(title: "Email Already In Use", message: "Please try again with an email that is not in use by another account", preferredStyle: .alert)
                    let cancelAction  = UIAlertAction(title: "Try Again", style: .cancel, handler: nil)
                    emailInUse.addAction(cancelAction)
                    self.present(emailInUse, animated: true, completion: nil)
                    break;
                    
                case .invalidEmail:
                    let invalidEmail = UIAlertController(title: "This email address is invalid ", message: "This email address is invalid please try again with a different email address", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                    invalidEmail.addAction(cancelAction)
                    self.present(invalidEmail, animated: true, completion: nil)
                    break;
                
                case .weakPassword:
                    let weakPassword = UIAlertController(title: "Please try again with a stronger password", message: "The password you have chosen to make your accunt has been deemed as weak, please try again with a different password", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                    weakPassword.addAction(cancelAction)
                    self.present(weakPassword, animated: true, completion: nil)
                    break;
                    
                    
                case .noSuchProvider:
                    let noProviderAlert = UIAlertController(title: "Credentials have not been verified", message: "Your user credentials have not been verfied, please try signing in again", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                    noProviderAlert.addAction(cancelAction)
                    self.present(noProviderAlert, animated: true, completion: nil)
                    break;
                default:
                    let generalError = UIAlertController(title: "We are having trouble signing you up", message: "Please try again at a later time", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                    generalError.addAction(cancelAction)
                    self.present(generalError, animated: true, completion: nil)
                }
            }
            
        }
        
    }
    
    
 }
