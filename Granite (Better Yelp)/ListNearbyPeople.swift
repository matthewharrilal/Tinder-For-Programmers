//
//  ListNearbyUsers.swift
//  Granite (Better Yelp)
//
//  Created by Matthew on 7/24/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import Alamofire


class ListNearbyPeople: UITableViewController, UISearchBarDelegate {
    var hardCodedUsers = [HardCodedUsers]()
    //var userUsernames: [HardCodedUsers] = []
    var profileController = [ProfileThatUsersSee]()
    var filteredSearchArray = [HardCodedUsers]()
    var databaseRef = Database.database().reference().child("users")
    let cellID = "nearbyPeopleCell"
    var refHandle: UInt!
    var username: String?
    var githubLink: String?
    var compLanguage: String?
    @IBOutlet weak var searchBar: UISearchBar!
    var isSearching = false
    var userBio: String?
    
    
    
    //let database = Database.database().reference().dictionaryWithValues(forKeys: String([users]))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference()
        fetchUsers()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        //        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.returnKeyType = UIReturnKeyType.done
        
    }
    
    func fetchUsers() {
        // Fetches users from database
        refHandle = databaseRef.child("users").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject],
                let username = dictionary["username"] as? String,
                let email = dictionary["email"] as? String,
                let fullName = dictionary["fullName"] as? String,
                let password = dictionary["password"] as? String,
                let githubName = dictionary["githubName"] as? String,
                let githubLink = dictionary["githubLink"] as? String,
                let compLanguage = dictionary["compLanguage"] as? String,
                let userBio = dictionary["userBio"] as? String,
                let profileImageURL = dictionary["pic"] as? String
                else {
                    // So the reason i am thinking we are getting this bad instruction error is becauase the bio is something the user doesnt need to sign up therefore we dont need to initalize it and maybe we can go about it the same way we went about the profile pic, now the problem we are getting here is that it is finding nil in the database meaning theres no way to store that in firebase
                    
                    //let user = HardCodedUsers(username: String(describing: DataSnapshot()) )
                    
                    // What shpuld we pass in this username
                    
                    //user.setValuesForKeys(dictionary)
                    print("WHAT")
                    return
            }
            let user =  HardCodedUsers(username: username, email: email, fullName: fullName, password: password, githubName: githubName, computerLanguage: compLanguage, githubLink: githubLink, userBio: userBio)
            // So essentially what we are doing here is that we are passing these new childs we are adding in our firebase database into out initalizers therefore it will satisfy the users creating of their account
            // And this is what we call an object and we know that an object is of a type class that has been declared and we create these objects so we can pass around data from that class much faster and efficiently
            self.hardCodedUsers.append(user)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! UITableViewCell
        username = currentCell.textLabel?.text
        if isSearching {
            username = filteredSearchArray[indexPath.row].username
        } else {
            username = hardCodedUsers[indexPath.row].username
            githubLink = hardCodedUsers[indexPath.row].githubLink
            compLanguage = hardCodedUsers[indexPath.row].computerLanguage
            userBio = hardCodedUsers[indexPath.row].userBio
           
            
            
            // So essentially what we are doing here is that we are creating a pathway to a specific node in our firebase database and we are doing that with the indexPath therefore what we are doing in this overwritten function is that we are taking our optinal variable and creating a pathway to our firebase database for the corresponding node when the user taps on the cell
        }
        
        performSegue(withIdentifier: "toProfile", sender: self)
        
          }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return hardCodedUsers.count
        if isSearching {
            return filteredSearchArray.count
        } else {
            return hardCodedUsers.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        //        // let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        let cell = tableView.dequeueReusableCell(withIdentifier: "nearbyPeopleCell", for: indexPath)
        
        if isSearching  {
            print("The filtered search results are getting printed on the table view cells")
            cell.textLabel?.text = filteredSearchArray[indexPath.row].username
        } else {
            print("The filtered search results are not getting printed on the table view cells")
            cell.textLabel?.text = hardCodedUsers[indexPath.row].username
            // This is what is getting hit this else statement
        }
        
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            filteredSearchArray = hardCodedUsers.filter{
                //$0.username == searchBar.text!
                $0.username.lowercased().range(of: (searchBar.text?.lowercased())!) != nil
            }
            tableView.reloadData()
        }
    }
    
    // So the problem we are essentially having is that we are stacking the views on the one profile view controller but when we get the second one that is the correct one so there is an error somewhere in the transition
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            if identifier == "toProfile" {
                let profileViewController = segue.destination as? ProfileThatUsersSee
                
                print(profileViewController?.username)
                profileViewController?.username = self.username
                profileViewController?.compLanguage = self.compLanguage
                profileViewController?.githubLink = self.githubLink
                profileViewController?.userBio = self.userBio
              
              
                // So essentially what we are doing here is that we are taking the optional variables we have declared in the profile that users see view controller and what we are doing with it is that we are assigning these variables the data from the optional variables we have declared in this view controller file
                
                // And we know that over the course of this view controller we assigned the optional variables in this view contoller equal to the nodes in our firebase therefore what we are essentially doing here is that we are setting the nodes in firebase equal to the variables in our other view controller
                
                // And the reason we did this is as opposed to the other view controller is because in the other file we couldnt do it there therefore by  getting this data in a dynamic function which we want meaning that we are getting the users information from our firebase database depending on which cell the user taps on and this essentially gives us the option to get different users information as opposed to only the current users information
                
            }
            
        }
    }
    
}
