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
import SystemConfiguration


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
    var roughLocationKey: String?
    
    
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
    
    func fetchUsersLocation() {
//        if let userRoughLocation = HardCodedUsers.current?.roughLocation {
//            self.roughLocationKey = userRoughLocation
//        }

        guard self.roughLocationKey != nil else { return }

        
        databaseRef.child("usersByLocation").child(self.roughLocationKey!).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                // So essentially what is happening here is that we a
                else { return }
            
            self.hardCodedUsers = [HardCodedUsers]()
            self.filteredSearchArray = [HardCodedUsers]()
          
            
            for userByLocation in snapshot {
                
                print(userByLocation.key)
                
                
                
                
                //retrieve the user data
                // it comes back as a snapshot
                // initialize the user with the snapshot (instead of all of the values)
                // add to the array
                // ???
                // success!!!!!
                let user = HardCodedUsers(username: userByLocation.key, email: "", fullName: "", password: "", githubName: "", computerLanguage: "", githubLink: "", userBio: "", roughLocation: "", uid: userByLocation.key)
                //                user.pic = "https://firebasestorage.googleapis.com/v0/b/granite3-dbd3a.appspot.com/o/profileImage%2F76129601-0D2E-48CF-B758-4890C11F7A72?alt=media&token=fce19b8b-5259-48ce-b1a2-8bf629b4da8c"
                self.hardCodedUsers.append(user)
                // So essentially what we are doing here is that we are iterating over the items in the snapshot that grabs all the objects in the under the roughLocation which represent the inialized property we give each user therefore we are returning the key therefore we have to return the value
                
                // Now notice that when we print the value we get the pseudocode we used to display the key mainly for organizational purposes therefore we have to print the key and use that to retrieve the users info
                
                // THE WAY WE ARE GETTING ONLY THE USERS IN THE SAME LOCATION TO SHOW UP IS BY INITALIZING THE USER WITH A SNAPSHOT OF THE ROUGHLOCATION and anyone who has the same value for the rough location child value will be displayed becuase we are watching the values for these childs
            }
            
            
            
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
//            //
//                               cell.textLabel?.text = filteredSearchArray[indexPath.row].username
//                        cell.detailTextLabel?.text = filteredSearchArray[indexPath.row].computerLanguage
//            
            UserService.show(forUID: filteredSearchArray[indexPath.row].username, completion: { (user) in
                guard let user = user else {
                    return
                }
                
                cell.textLabel?.text = user.username
                // What is happening here is really a work of art therefore let me explain what is happening here so what this userService.show function does is that it contains a daatabase reference to the uids of the users
                cell.detailTextLabel?.text = user.computerLanguage
                
            })

            
            
            
        } else {
                     UserService.show(forUID: hardCodedUsers[indexPath.row].username, completion: { (user) in
                guard let user = user else {
                    return
                }
                
                cell.textLabel?.text = user.username
                // What is happening here is really a work of art therefore let me explain what is happening here so what this userService.show function does is that it contains a daatabase reference to the uids of the users
                cell.detailTextLabel?.text = user.computerLanguage
                
            })
            
            
            
            //cell.textLabel?.text = hardCodedUsers[indexPath.row].username
            
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
                //                $0.username.lowercased().range(of: (searchBar.text?.lowercased())!) != nil
                $0.username.lowercased().range(of: (searchBar.text?.lowercased())!) != nil
                //                $0.computerLanguage?.lowercased().range(of: (searchBar.text?.lowercased())!) != nil
                // return true
                
                
            }
            
            filteredSearchArray += hardCodedUsers.filter{
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
