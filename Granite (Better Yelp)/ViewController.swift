//
//  ViewController.swift
//  Granite (Better Yelp)
//
//  Created by Matthew on 7/22/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseAuthUI
import FirebaseDatabase
import SystemConfiguration

class LocatioViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var postalCode: String?
    // Map
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var interestsTextField: UITextField!
    
    var hardCodedUsers: HardCodedUsers?
    
    var zipCodeChecker: String?
    var zipCodeKeys = [String]()
    func logout() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let logInViewController = storyboard.instantiateViewController(withIdentifier: "Home")
        let viewController = LocatioViewController()
        self.present(viewController, animated: true, completion: nil )
        
        // So this function is basically the function we call whenever the user would want to logout from their account
        
        // and how we went about executing this code is that we set this new let constant called storyboard and what this essentially does is that representing the main storyboard
        // In the next line of code we are declaring a new let constant called logInViewController and what this let constant essentially does is that we take the storyboard constant that we declared in the previous line of code and what we do with that is that we are using this new let constant we are declaring to reprsent the transition that occurs when the the user wants to go from wherever they are in the main storyboard and go to the view controller they want to end up in by giving the view controller an identifier for where they want to end up in and depending on where you call this function that how the transition is going to occur for example we call this function in the log out button action because when we press the logout button we want to be transition to the view controller that we gave the identifier for
        
    }
    
    @IBAction func applyUnwind(_ segue: UIStoryboardSegue) {
        
        
    }
      
    //The submit button
    @IBAction func submitButton(_ sender: UIButton) {
       print("This is the end of the line for you")
        // We should get in the habit of using print statements to see if our code is executing properly
       self.performSegue(withIdentifier: "toNearbyPeople", sender: self)
    }
    
    var radius: Double = 50.0
    // Here we are essenitally declaring a new variable and what this variable is of type double and we set its value equalt 50 and the reason we are doing this is because we are basically setting it to match the default value of the slider to 50
    // Refer to the settings view controller after this step to see what comes next
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let roughLocationKey = String(format: "%.1f,%.1f", location.coordinate.latitude, location.coordinate.longitude).replacingOccurrences(of: ".", with: "%2e")
        
       
        
        guard let currentUser = HardCodedUsers.current else {
            return
        }
        
        currentUser.roughLocation = roughLocationKey
        if Auth.auth().currentUser?.uid != nil {
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("roughLocation").setValue(roughLocationKey)
        Database.database().reference().child("usersByLocation").child(roughLocationKey).child((Auth.auth().currentUser?.uid)!).setValue(["roughLocation": "roughLocation"])
        }
        
        // So essentially what we are doing is that we are creating a new let constant called location and setting that equl to the locations array and the very first element by setting the index value we want equal to 0 the reason we want the very first element is becuase we want the users most recent position, and the reason it is the first one rather than the last one because the array can also be populated with elements that we do not care about therefore we only care about the users most updated location therefore it would be the very first element of the array
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        // So what is essentially happening in these lines of code is that so fist of all we have to gove the coordinates a span of how far we want the location to cover so we set both the latitude and longitude equal to 0.01 this is just coordinational jargon that is not neccesary to understand
        
        // In the nex line of code what we are essentially doing is that we are saying that our 2d location eaning the zooming ability is that we want it to reference the latitude and longitude spans that we declared in he previous line of code and we set that equal to 0.01 thefore that makes sense we only want to be able to zoom in at a span of 0.01 north east south and west
        
        // So basically what is happening is that we are combining the to let constants previously declare din this third line of code and essentially what is happening is the we are combining the data that covers the span of the users locations as well as the ability to zoom in the users locations span and therefore making it the region
       
       map.setRegion(region, animated: true)
        // So basically in this line of code we are setting the region where as we declared it in the line previous to this code
        
        self.map.showsUserLocation = true
        //   print(location.altitude) // This is optional if you want to know the users current altitude
       
        if Auth.auth().currentUser?.uid == nil {
        print("The user can not be tracked yet")
            return
        }
        else {
         Database.database().reference().child("users").child(roughLocationKey).child((Auth.auth().currentUser?.uid)!).setValue(["Latitude": location.coordinate.latitude, "Longitude": location.coordinate.longitude, "altitude": location.altitude])
            
            manager.stopUpdatingLocation()
            return
        }
  
        // The reason it is breaking is because the we are getting the location of the current user who is logged in however if the user just creates an account they will not have a uid by the time the app charts their location
         }
    // But essentially this function will b
    
    let manager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        showAlert()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        self.map.delegate = self
        self.map.showsUserLocation = true
        self.map.setUserTrackingMode(.follow, animated: true)
        
        // So essentially what is happening in the first4 lines of these manager methods is that we are letting this class receive update eventes by using the proper method and then setting it equal to self
        
        // In the next line of code we are saying that we want the desired accuracy of manager and as we know manager refers to our locationd data so essentially what we are saying is that we want the accuracy for this location data to always be at its best
        
        // In the next line of code what we are essentially doing is that we are telling our location data whic is stored in our let constant called manager that since we are using the users location we want to ask for authorization whenever they are using the app therefore we are requesting their authorization to use their location whenver they start to use the app
        
        // In the last line of code what we are essentially doing is that we want to update their location based on the amount of times we call this function therefore we would only call this function once
        
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        let currentLocation = manager.location
        
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
        // Now lets talk about what this function does exactly and what it does is that we have this function called dismissKeyboard and within the function body what that does exaclty so essentially what we are doing is when we refer back to our tap constant that we amade we declared the argument label action to be of type "dismissKeyobard" so first and foremost we know that actions are essentially anything that are going to be serving as an action or something that we are going to put fucntionality within therefore by declaring this function the same name as the action type within the tap constant we are basically saying that thats what the tap is going to do when it is passed in the view.addGestureRecognizer that we are going to be doing exactly that dismissing the keybord and we gurantee this is going to happen because  by writng inside of the function body of thsis function by writing the view which again refers to the variable called view of type UIView that refers to the root view controller and by adding the method called endEditing which is pretty self explanatory and we pass in the boolean value true and what this essentially does is that what this function basically does is that it lets the user end the edtitng of the text but the reason we cant just call this function and expect it to dismis the keyboard is becuase even if we do call it the function doesnt know what editing in the view to end
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        func showLocationDisabledPopUp() {
            let alertController = UIAlertController(title: "Background Location Access Disabled ", message: "In order to have tasks completed this application needs your location", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    
                    
                }
            }
            alertController.addAction(openAction)
            self.present(alertController, animated: true, completion: nil)
        }
        if status == CLAuthorizationStatus.denied {
            showLocationDisabledPopUp()
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ListNearbyPeople {
            viewController.roughLocationKey = String(format: "%.1f,%.1f", self.map.centerCoordinate.latitude, self.map.centerCoordinate.longitude).replacingOccurrences(of: ".", with: "%2e")
            print("Map is centered at location key \(viewController.roughLocationKey)")
        }
   
        
    }
    
}


