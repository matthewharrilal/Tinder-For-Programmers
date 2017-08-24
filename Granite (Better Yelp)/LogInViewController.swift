//
//  LogInViewController.swift
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
import FirebaseStorage
import FirebaseDatabase
import Alamofire
import QuartzCore
import SystemConfiguration

protocol LogInViewControllerDelegate: class {
func finishLoggingIn()

}


class LogInViewController: UIViewController {
    var error = Error.self
    
    @IBOutlet weak var newUserButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let databaseRef = Database.database().reference(fromURL: "https://granite3-dbd3a.firebaseio.com")
    //  Making our references at the start of the project makes our lives easier in terms of now we know what we already have and we just declare them here so we are not doing it while we go through the project
    
    var activityIndicatior: UIActivityIndicatorView = UIActivityIndicatorView()
    @IBAction func logInButton(_ sender: UIButton) {
        showAlert()
        activityIndicatior.center = self.view.center
        activityIndicatior.hidesWhenStopped = true
        activityIndicatior.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicatior)
        
        activityIndicatior.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        activityIndicatior.stopAnimating()
    UIApplication.shared.endIgnoringInteractionEvents()
        if emailTextField.text != "" {
        }
        else {
            // logInCredentialsIsEmpty()
        }
        
        if passwordTextField.text != "" {
        }
            
        else {
        }
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            // if there is an error meaning that it will be the opposite of nil
            if let error = error {
                self.logInCredentialsIsEmpty(error: error)
                print(error.localizedDescription)
                
                 return
                // This get hits when you are signing in with a user that doesnt exist and the opposite for the else statement
                // The reason we werent having the user saving to user defualts is becuase we had the return command line commented out therefore when it was checking if the if condition was true it never left therefore getting confused thonking it was an error
            } else {
                print("User is just signed in and their user defaults has not been set yet")
                UserService.show(forUID: (user?.uid)!, completion: { (user) in
                    if let user = user {
                        HardCodedUsers.setCurrent(user, writeToUserDefaults: true)
                        self.finishLoggingIn()
                        print("User defaults has now been set")
                    }
                    else {
                        print("Error: User does not exist")
                        return
                    
                    }
                })
                self.performSegue(withIdentifier: "toHome", sender: nil)
                
            }
        }
       // So essentially what we are doing here is that we are doing here is that if the error is not equal to nil meaning that there is an error they will be me with the proper log in alert based on the localized description error and where as in the else statement if everything basically checks out and everything is verified they can be on their merry way
        
        // The reason we changed the segue from the button to the next view controller to the home to the next view controller is  becuase if we left it that way we would have been stuck with a button that just segues even if the alerts are present and we see that we do not want that if their is an error we want our users to be presented with an error 
    
    }
    func finishLoggingIn() {
        print("User is done logging in from the log in view controller")
    }
    
    func logInCredentialsIsEmpty(error: Error) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            let emptyLogInCredentials = UIAlertController(title: "Missing Log In Input", message: "Some of your log in credentials seem to be empty please double check the required fields", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "You are forgiven", style: .default, handler: nil)
            emptyLogInCredentials.addAction(cancelAction)
            self.present(emptyLogInCredentials, animated: true, completion: nil)
        }
        else {
            switch(error.localizedDescription) {
            case "The email address is badly formatted.":
                let invalidEmailAlert = UIAlertController(title: "This email address is badly formatted", message: "Please try again with a different email address, if not please create an account", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                invalidEmailAlert.addAction(cancelAction)
                self.present(invalidEmailAlert, animated: true, completion:  nil)
                break;
                
            case "There is no user record corresponding to this identifier. The user may have been deleted.":
                let nonExistentUser = UIAlertController(title: "Non-existent Account", message: "This account does not correspond to any records within our database", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                nonExistentUser.addAction(cancelAction)
                self.present(nonExistentUser, animated: true, completion: nil)
                break;
            case "Try a different password.":
                let invalidPassword = UIAlertController(title: "Wrong Password", message: "Try logging in with a different password", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                invalidPassword.addAction(cancelAction)
                self.present(invalidPassword, animated: true, completion:  nil)
                break;
                
                case "Error: User does not exist":
                    let invalidAccount = UIAlertController(title: "This User Does Not Exist", message: "Please try logging in with a different account", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                invalidAccount.addAction(cancelAction)
                self.present(invalidAccount, animated: true, completion:  nil)
                    break;
                
            default:
                let logInFailedAlert = UIAlertController(title: "Trouble Logging In", message: "We are having trouble logging you in", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                logInFailedAlert.addAction(cancelAction)
                self.present(logInFailedAlert, animated:  true, completion:  nil)
            }
            
        }
        
        
    }
    
    
    
    func emailIsAlreadyRegistered() {
        let registeredEmail = UIAlertController(title: "Email is already registered with an account", message: "Try using another email adress to log in", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Allow me to try again", style: .default, handler: nil)
        registeredEmail.addAction(cancelAction)
        self.present(registeredEmail, animated: true, completion: nil)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // The reason we need this function is because this will show us the defualt back button on the next screen as oppose to showing us the default back button from both the initial and the next screen
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        newUserButton.layer.cornerRadius = 10
        emailTextField.layer.cornerRadius = 5
        emailTextField.layer.masksToBounds = true
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.layer.masksToBounds = true
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
    
    
    
    
}



