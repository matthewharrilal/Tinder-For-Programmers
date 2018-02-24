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
import Kingfisher
import SystemConfiguration
import MessageUI
import KeychainSwift


class ProfileThatUsersSee: UIViewController, MFMailComposeViewControllerDelegate  {
    var username: String?
    var githubLink: String?
    var compLanguage: String?
    var userBio: String?
    var imageURLs = [String]()
    var fullName: String?
    
    
    var hardCodedUser: HardCodedUsers?
    
    
    var refHandle: UInt!
    var profileImageURL:String?
    var objectUser: HardCodedUsers?
    @IBOutlet weak var profilePic: UIImageView!
    
    // Let us create an object for our class
    
    
    // When it says that your class needs initalizers you can just make the property optional therefore you dont have to initalize the property for future references to come
    var databaseRef = Database.database().reference()
    
    @IBOutlet weak var computerLanguageLabel: UILabel!
    @IBOutlet weak var githubLinkLabel: UILabel!
    
    @IBOutlet weak var userBioTextView: UITextView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    @IBAction func toWebBrowser(_ sender: UIButton) {
        openURL(url: githubLinkLabel.text)
    }
    func openURL(url: String!) {
        if let url = URL(string: url!) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    func circularImage(photoImageView: UIImageView?)
    {        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAlert()
        circularImage(photoImageView: profilePic)
        // We are compressing the images so the upload rate to our image view is much faster for the user
        
        
        let user = self.objectUser
        UserService.show(forUID: (user?.username)!, completion: {(user) in
            guard let user = user else {
                return
            }
            self.usernameLabel.text = user.username
            self.githubLinkLabel.text = user.githubLink
            self.computerLanguageLabel.text = user.computerLanguage
            self.userBioTextView.text = user.userBio
            self.userBioTextView.isEditable = false
            self.fullName = user.fullName
            // So essentially what this user service .show function does is that is displays the data for the authenticated user and we have to decide what part of that data we actually want
            // And the reason we want to show for uid the user.username because in the objectUser the username is where we are storing the keys for the uids therefore this show function is grabbing all the user data from that uid and we akre specifing which data we want and where we want it
            self.databaseRef.child("users").child(user.username).observeSingleEvent(of: .value, with: { (snapshot) in
                if let pictureURL = user.pic {
                    self.profilePic.loadImageUsingCacheWithURLString(urlString: pictureURL)
                    //                    let url = URL(string: pictureURL)
                    //                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    //                        if error != nil {
                    //                            print(error?.localizedDescription)
                    //                            return
                    //                        }
                    //                        DispatchQueue.main.async {
                    //                            self.profilePic.image = UIImage(data: data!)
                    //                        }
                    //                    }).resume()
                }
            })
            
            // So essentially what we are doing here is similar to what we are doing to get the rest of the results displayed on the proifle that users see view controller therefore let me talk about it we are first breaking in to all the uids of the users and observing the values of all the childs within those uids then we are essentially assigning that data to the image view the value for the child pic at least
            
        })
        
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
    
    //
    func removeAuthListener (authHandle: AuthStateDidChangeListenerHandle?)
    {
        if let authHandle = authHandle{
            
            Auth.auth().removeStateDidChangeListener(authHandle)
            
        }
        // So as we know what is happening is that what a handler does is that creates and returns an action with the specified behavior so what this does is almost like a setting function because what we are essentially doing is that we are changing the code within firebase to say change the listener block to a block that essentailly tells us that the user has signed out
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureEmail() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        let keychain = KeychainSwift()
        mailComposerVC.setToRecipients([keychain.get("email")!])
        mailComposerVC.setSubject("Regarding Developer Interests From Granite")
        
        mailComposerVC.setMessageBody("Greetings \(String(describing: fullName!))! There has been a mutual connection established between yourself and \(String(describing: keychain.get("fullName"))). Discuss further where you should meet!", isHTML: false)
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Please try sending the email again", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
        sendMailErrorAlert.addAction(cancelAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func sendEmailButton(_ sender: UIButton) {
        let mailComposeViewController = configureEmail()
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
        else {
            showMailError()
        }
    }
    
}
