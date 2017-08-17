//
//  SettingsViewController.swift
//  Granite (Better Yelp)
//
//  Created by Matthew on 7/25/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class SettingsViewController: UIViewController {
    
    var parentVC: ViewController!
    // so here what we are essentially doing is that we are creating a new variable called parentVC and what that basically means is that its our parent view cntroller which means that all the view controllers that are displayed are a result of this view controller we are currently in 
    var radiusValue: Float = 50.0
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var label: UILabel!
    
    @IBAction func slider(_ sender: UISlider) {
        label.text = String(sender.value)
        // What these lines of code essentially do is that it lets us gives this slider values and the reason we we connect this label is becuase we want to give this label functionality
        
        
        // So essentially what I want to do right now is that I want as the user progressed the slider I want the radius of the distance that is covered to be moved
        
        // SO to go about this what we have to do is that we want to create an unind segue that is going to store this data and the grind never stops
        
        
        parentVC.radius = Double(sender.value)
        
        // So before we get into anything specific its alright if you dont understand everything as long as you have the drive to keep going and learn more and more everyday without doubts an hesitations then you will succeed no doub 
        // There is no if or buts in work ethic 
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        radiusSlider.value = radiusValue
        label.text = String(radiusValue)
        
    }
    
    
    
    
       
}
