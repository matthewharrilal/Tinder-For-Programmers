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
import Kingfisher


class ListNearbyPeople: UITableViewController, UISearchBarDelegate {
    var hardCodedUsers = [HardCodedUsers]()
    //var userUsernames: [HardCodedUsers] = []
    var profileController = [ProfileThatUsersSee]()
    var filteredSearchArray = [HardCodedUsers]()
    var databaseRef = Database.database().reference()
    var storageRef = Storage.storage()
    let cellID = "nearbyPeopleCell"
    var refHandle: UInt!
    var username: String?
    var selectedUser: HardCodedUsers?
    var githubLink: String?
    var compLanguage: String?
    @IBOutlet weak var searchBar: UISearchBar!
    var isSearching = false
    var userBio: String?
    var x: HardCodedUsers?
    var profileImageURL: String?
    
    
    //let database = Database.database().reference().dictionaryWithValues(forKeys: String([users]))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference()
        //fetchUsers()
        fetchUsersLocation()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        //        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    func fetchUsersLocation() {
        
        let roughLocation = HardCodedUsers.current?.roughLocation
        var truncatedLocationHolder = databaseRef.child("usersByLocation").child(roughLocation!).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                // So essentially what is happening here is that we a
                else { return }
            
            self.hardCodedUsers = [HardCodedUsers]()
            let dispatchGroup = DispatchGroup()
            
            for userByLocation in snapshot {
                
                print(userByLocation.key)
                
                
                
                
                //retrieve the user data
                // it comes back as a snapshot
                // initialize the user with the snapshot (instead of all of the values)
                // add to the array
                // ???
                // success!!!!!
                let user = HardCodedUsers(username: userByLocation.key, email: "", fullName: "", password: "", githubName: "", computerLanguage: "", githubLink: "", userBio: "", roughLocation: "")
//                user.pic = "https://firebasestorage.googleapis.com/v0/b/granite3-dbd3a.appspot.com/o/profileImage%2F76129601-0D2E-48CF-B758-4890C11F7A72?alt=media&token=fce19b8b-5259-48ce-b1a2-8bf629b4da8c"
                self.hardCodedUsers.append(user)
                // So essentially what we are doing here is that we are iterating over the items in the snapshot that grabs all the objects in the under the roughLocation which represent the inialized property we give each user therefore we are returning the key therefore we have to return the value
                
                // Now notice that when we print the value we get the pseudocode we used to display the key mainly for organizational purposes therefore we have to print the key and use that to retrieve the users info
            }
            
            
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
        })
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
                let userBio = dictionary["userBio"] as? String
                
                else {
                    // So what is essentially happening here is that we should not get confused between adding a node to our firebase database location as well and initalizing a new user
                    
                    // The difference between the two is that when we initalize a user it means we are creating the user with the properties they must have to be created such as a username and password where this fetch users function stores them and and nodes in our firebase database in the form of a dictionary holding values within the keys
                    print("WHAT")
                    return
            }
            //            if let picURL = dictionary["pic"] as? String {
            //
            //            } else {
            //                //no image case
            //                print("The image could not be retrieved")
            //            }
            
            //            let user =  HardCodedUsers(username: username, email: email, fullName: fullName, password: password, githubName: githubName, computerLanguage: compLanguage, githubLink: githubLink, userBio: userBio )
            //            self.x = user
            // So essentially what we are doing here is that we are passing these new childs we are adding in our firebase database into out initalizers therefore it will satisfy the users creating of their account
            // And this is what we call an object and we know that an object is of a type class that has been declared and we create these objects so we can pass around data from that class much faster and efficiently
            //            self.hardCodedUsers.append(user)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        
    }
    //    func childChanged() {
    //    refHandle = databaseRef.child("users").observe(.childChanged, with: { (snapshot) in
    //        guard let key = snapshot.key as? String,
    //        guard let value = snapshot.value as? String else{return}
    //
    //        if key ==
    //    })
    //    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! UITableViewCell
        username = currentCell.textLabel?.text
        if isSearching {
            self.selectedUser = filteredSearchArray[indexPath.row]
        } else {
            self.selectedUser = hardCodedUsers[indexPath.row]
            
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
            // Somehow we have to figure out a way to display the users that are in the rough location
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              let cell = tableView.dequeueReusableCell(withIdentifier: "nearbyPeopleCell", for: indexPath)
        if isSearching  {
            print("The filtered search results are getting printed on the table view cells")
                   cell.textLabel?.text = filteredSearchArray[indexPath.row].username
            cell.detailTextLabel?.text = filteredSearchArray[indexPath.row].computerLanguage
            
            
        } else {
            print("The filtered search results are not getting printed on the table view cells")
            
            UserService.show(forUID: hardCodedUsers[indexPath.row].username, completion: { (user) in
                guard let user = user else {
                    return
                }
                
                cell.textLabel?.text = user.username
                // What is happening here is really a work of art therefore let me explain what is happening here so what this userService.show function does is that it contains a daatabase reference to the uids of the users 
                
                
            })
            
            
            
            //cell.textLabel?.text = hardCodedUsers[indexPath.row].username
            cell.detailTextLabel?.text = hardCodedUsers[indexPath.row].computerLanguage
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
                                $0.username.lowercased().range(of: (searchBar.text?.lowercased())!) != nil
                
                
            }
            
            filteredSearchArray = hardCodedUsers.filter{
                $0.computerLanguage?.lowercased().range(of: (searchBar.text?.lowercased())!) != nil
            }
            tableView.reloadData()
        }
    }
    
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            if identifier == "toProfile" {
                let profileViewController = segue.destination as? ProfileThatUsersSee
                
                profileViewController?.objectUser = self.selectedUser
                self.selectedUser = nil
            }
            
        }
    }
    
}
