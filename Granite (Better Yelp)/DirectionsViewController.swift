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
        //markerPinOnTheMap.icon
        
        
        // markerPinOnTheMap.icon
        // we can use this later this is for customization
        
        
        // So what we are essentially doing right now is that we are creating a pin on our map view that pins our exact coordinates at homevvvvv
        // navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: "next" )
        
        // 40.718448, -74.002527
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


// Location Manager Delegate class
//extension   DirectionsViewController : CLLocationManagerDelegate
//{
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
//    {
//        let location = locations.last
//        
//        // Force unwrapping need to implement optional wrapping. Force is dangerous
//        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 10)
//        //Getting coordinates
//        currentLocation = (location?.coordinate.latitude)!
//        currentLocation = (location?.coordinate.longitude)!
//        //Location is hardcoded to Impact Hub location
//        let origin = GoogleMapsDirections.Place.coordinate(coordinate: GoogleMapsService.LocationCoordinate2D(latitude: currentLocLatitude, longitude: currentLocLongitude))
//        let destination = GoogleMapsService.Place.coordinate(coordinate: GoogleMapsService.LocationCoordinate2D(latitude: latitude, longitude: longitude))
//        
//        
//        //Getting web url with coordinates from Google Directions API
//        GoogleMapsDirections.direction(fromOrigin: origin, toDestination: destination) { (response, error) -> Void in
//            // Check Status Code
//            guard response?.status == GoogleMapsDirections.StatusCode.ok else {
//                // Status Code is Not OK
//                debugPrint(response?.errorMessage ?? "")
//                return
//            }
//            
//            // Use .result or .geocodedWaypoints to access response details
//            // response will have same structure as what Google Maps Directions API returns
//            //debugPrint("it has \(response?.routes.count ?? 0) routes")
//            
//            print(response)
//            let path = (response?.toJSON())!
//            
//            // print(path)
//            let pt = JSON(path)
//            print(pt)
//            let polyLinePath = pt["routes"][0]["overview_polyline"]["points"].stringValue
//            self.addPolylineWithEncodedStringInMap(encodedString: polyLinePath)
//            
//        }
//        
//        
//        
//        mapView?.animate(to: camera)
//        //Finally stop updating location otherwise it will come again and again in this delegate
//        self.locationManager.stopUpdatingLocation()
//    }
//}
