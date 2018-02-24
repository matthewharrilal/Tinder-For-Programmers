//
//  DirectionsViewController.swift
//  Granite (Better Yelp)
//
//  Created by Matthew on 7/27/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import GoogleMapsDirections
import Alamofire
import SwiftyJSON
import MapKit

class DirectionsViewController: UIViewController {
    //40.606035, -73.767939
    var mapView: GMSMapView?
    
    var secondMapView: GMSMapView?
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let camera = GMSCameraPosition.camera(withLatitude: 40.606035, longitude: -73.767939, zoom: 10)
        mapView = GMSMapView.map(withFrame: frame, camera: camera)
        view = mapView
        let currentLocation = CLLocationCoordinate2DMake(40.606035, -73.767939)
        let markerPinOnTheMap = GMSMarker(position: currentLocation )
        markerPinOnTheMap.title = "Home"
        markerPinOnTheMap.map = mapView
        
        let frame1 = CGRect(x: 0, y: 0, width: 20, height: 20)
        let camera1 = GMSCameraPosition.camera(withLatitude: 40.718448, longitude:  -74.002527, zoom: 10)
        //      view = secondMapView // dont need this there is ionly one view
        var  currentLocation1 = CLLocationCoordinate2DMake( 40.718448,  -74.002527)
        let markerPinOnTheMap1 = GMSMarker(position: currentLocation1 )
        markerPinOnTheMap1.title = "Make School"
        markerPinOnTheMap1.map = mapView
        
        let originCoord = CLLocationCoordinate2DMake(40.606035, -73.767939)
        let destinationCoord = CLLocationCoordinate2DMake(40.718448, -74.002527)
        
        
        let apiKey = "AIzaSyAY5GU2CcLfugDcBvDPPYNNvTO3a9sWoyA"
        
    }
    
    func addPolylineWithEncodedStringInMap(encodedString : String)
    {
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5
        polyline.strokeColor = UIColor.black
        polyline.map = mapView
    }
}


