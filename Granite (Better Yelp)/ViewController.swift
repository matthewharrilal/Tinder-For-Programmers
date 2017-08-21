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
    
    var postalCode: String?
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
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        // So essentially what we are doing is that we are creating a new let constant called location and setting that equl to the locations array and the very first element by setting the index value we want equal to 0 the reason we want the very first element is becuase we want the users most recent position, and the reason it is the first one rather than the last one because the array can also be populated with elements that we do not care about therefore we only care about the users most updated location therefore it would be the very first element of the array
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
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
        
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
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


