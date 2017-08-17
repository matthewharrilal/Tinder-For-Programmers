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
import VideoBackground

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    // Map
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var interestsTextField: UITextField!
    
    
    
    var hardCodedUsers: HardCodedUsers?
    
    
    func logout() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let logInViewController = storyboard.instantiateViewController(withIdentifier: "Home")
        let viewController = ViewController()
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
       self.performSegue(withIdentifier: "toNearbyPeople", sender: nil)
    }
    
    var radius: Double = 50.0
    // Here we are essenitally declaring a new variable and what this variable is of type double and we set its value equalt 50 and the reason we are doing this is because we are basically setting it to match the default value of the slider to 50
    // Refer to the settings view controller after this step to see what comes next
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation], error: Error) {
        let location = locations[0]
        
        
        // So essentially what we are doing is that we are creating a new let constant called location and setting that equl to the locations array and the very first element by setting the index value we want equal to 0 the reason we want the very first element is becuase we want the users most recent position, and the reason it is the first one rather than the last one because the array can also be populated with elements that we do not care about therefore we only care about the users most updated location therefore it would be the very first element of the array
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        // So what is essentially happening in these lines of code is that so fist of all we have to gove the coordinates a span of how far we want the location to cover so we set both the latitude and longitude equal to 0.01 this is just coordinational jargon that is not neccesary to understand
        
        // In the nex line of code what we are essentially doing is that we are saying that our 2d location eaning the zooming ability is that we want it to reference the latitude and longitude spans that we declared in he previous line of code and we set that equal to 0.01 thefore that makes sense we only want to be able to zoom in at a span of 0.01 north east south and west
        
        // So basically what is happening is that we are combining the to let constants previously declare din this third line of code and essentially what is happening is the we are combining the data that covers the span of the users locations as well as the ability to zoom in the users locations span and therefore making it the region
        print(error.localizedDescription)
       map.setRegion(region, animated: true)
        // So basically in this line of code we are setting the region where as we declared it in the line previous to this code
        
        self.map.showsUserLocation = true
        //   print(location.altitude) // This is optional if you want to know the users current altitude
    }
    // But essentially this function will b
    
    let manager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        // So essentially what is happening in the first4 lines of these manager methods is that we are letting this class receive update eventes by using the proper method and then setting it equal to self
        
        // In the next line of code we are saying that we want the desired accuracy of manager and as we know manager refers to our locationd data so essentially what we are saying is that we want the accuracy for this location data to always be at its best
        
        // In the next line of code what we are essentially doing is that we are telling our location data whic is stored in our let constant called manager that since we are using the users location we want to ask for authorization whenever they are using the app therefore we are requesting their authorization to use their location whenver they start to use the app
        
        // In the last line of code what we are essentially doing is that we want to update their location based on the amount of times we call this function therefore we would only call this function once
        
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        // Lets refer to the problem we were currently having is that we were not able to get rid of the keyboard when the user decided to type in the task they wanted to be completed therefore what we had to do is write these three lines of code above this comment as well as the function declaration below this comment so lets tackle this code line by line
        
        // So first we declare a let constant called tap and it is of UITapGestureRecognizer we then set this equal to the method UITapGestureRecognizer and this method now takes in the parameters target as well as action and target is of type self meaning it is referring to the class it is located in which is in the class ViewController and then the second argument label or parameter is the action parameter and what this essentially does is that it tells us that type of action is of type "dismissKeyboard" and the reason that it is of type string with those combination of characters basically means that the string we just declared the type of action to be is going to match the name of the function we are soon going to name
        
        // The second line of this code basically means that when the user wants to dismiss the keyboard they have to tap anywhere on the screen and essentially what this line of code does is for example say you had more than one functionality on the screen and you didnt want to in a sense dismiss the rest of that functionality this line of code will basically keep that from happening and since in the line of code directly above this we said that the action is of type "dismissKeyboard" therfore the line of code we are currently talking about is that this tap does not cancel all the functinality in the view and we ensure this by setting it equal to the boolean value of true but for what we are building we have no other functionality on the screen therefore it is uneccesary to have this line of code in this file but it is almost like a security measure so that if we did the canceling of the functionality wouldnt occur
        
        // The next line of code essentially sets that we have added a new gesture called tap and the way we go about this is that we take this variable called view of type UIView and from there we assign it the property or method called addGestureReconizer and what this essentially does is that it attaches and recognizes a gesture to the view and what are we reconizing exactly? We are passing in the let constant called tap that we declared two lines of code above the line of code we are currently talking about which contains the gesture of dismissing the keyboard
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
        let viewController = segue.destination as? ListNearbyPeople
         let viewController1  = segue.destination as? DirectionsViewController
        
        // THE SETTINGS DOESNT WORK BUT WE CAN FOCIS ON THAT LATER
        if segue.identifier == "toSettings" {
            
            let vc = segue.destination as! SettingsViewController
            vc.parentVC = self
            vc.radiusValue = Float(radius)
            
            
        }
              
        if let identifier = segue.identifier {
            if identifier == "toMap" {
            viewController1?.view.reloadInputViews()
            }
        }
        
        
    }
    
   
    
}


