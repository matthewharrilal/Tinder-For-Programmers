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
                let compLanguage = dictionary["compLanguage"] as? String
                else {
                    // So the reason i am thinking we are getting this bad instruction error is becauase the bio is something the user doesnt need to sign up therefore we dont need to initalize it and maybe we can go about it the same way we went about the profile pic, now the problem we are getting here is that it is finding nil in the database meaning theres no way to store that in firebase
                    
                    //let user = HardCodedUsers(username: String(describing: DataSnapshot()) )
                    
                    // What shpuld we pass in this username
                    
                    //user.setValuesForKeys(dictionary)
                    print("WHAT")
                    return
            }
            let user =  HardCodedUsers(username: username, email: email, fullName: fullName, password: password, githubName: githubName, computerLanguage: compLanguage, githubLink: githubLink)
            
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
            // githubLink = hardCodedUsers[indexPath.row].githubName
            //            githubLink = hardCodedUsers[indexPath.row].githubName
            //            // So the problem we are essentially facing is that we can  only access our model class properties and thats it therefore what that means is that we can not other properties that werent initalized
        }
        //   username = hardCodedUsers[indexPath.row].username
        performSegue(withIdentifier: "toProfile", sender: self)
        
        // So essentially what made our code work was that because as oppose to the cell for row at function we are essentially setting the data here as oppose to in the cell for row we are only displaying the username of the user in the corresponding cell in the row and in addtion to that in the prepare for segue as we know we use that function when we want to pass data from one view controller to another therefore in combination of those two previous functions the prepare for segue function and the cell for row at those two together essentially show us the username of the user in the cell and pass the data from one view controller to another but that does not neccesarily mean that they set the data therefore with this did select row is what it essentially does is when we tap on the cell that passes the data from one view controller to another we have to set the data in the next view controller so by this works in our benefit because we want to pass the usernames of the users and set them in the next view controller as their username in the username label
        
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
        // So essentially we have to figure out a way to return data from firebase dynmaically, now the problem with the way we were doing it earlier is because there was no way to do it straight from the same view controller because to make the reference we would have to use the current user who is logged in uid and therefore we would have to populate the label for each user with the current user who is logged in info, therefore the reason we would do it here is because we wanted to pass the data thaty we get from firebase
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        //        // let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        let cell = tableView.dequeueReusableCell(withIdentifier: "nearbyPeopleCell", for: indexPath)
        //        cell.textLabel?.text = hardCodedUsers[indexPath.row].username        //   username = hardCodedUsers[indexPath.row].username
        //
        //        // So essentially what we are doing here is that we are is assigning the value of the cells that display the usernames of the other users to the variable username we declared at the top of the class and why we are doing this is becauase we want the username to be displaying the usernames of the users from firebase but still we have to pass that data over to the profile view controller and we know to do this we have to use the prepare for segue function
        //        //        // Set cell contents
        //        return cell
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
                //  So essentially we know that the username we gave declared earlier now contains the usernames of the users from firebase but yet we have to pass that on to the next view controller thats why we are in this function therefore we have to finda way to pass that data over
                //   print(username)
                print(profileViewController?.username)
                profileViewController?.username = self.username
                profileViewController?.compLanguage = self.compLanguage
                profileViewController?.githubLink = self.githubLink
                // So when we print this we are getting nil meaning nothing was assigned to it yet therefore we want to assign the cells usernames which we are doing in the lines of codes below
                // And why would weassign the label text to username that is essentially hard coding the label text for each cell that we tap on
                
                
                //profileViewController?.usernameLabel.text = username
                // we can not do this line of code above because we know that if we store the usernames within this username label.text variable only one username will get stored and thats what causes it to appear on every username when each cell is tapped
                
                
            }
            
        }
    }
    
}
