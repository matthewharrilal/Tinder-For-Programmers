//
//  AppDelegate.swift
//  Granite (Better Yelp)
//
//  Created by Matthew on 7/22/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import UIKit
import FirebaseAuthUI
import Firebase
import GooglePlaces
import GoogleMaps
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
//    func checkUserAgainstDatabase(completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
//        guard let currentUser = Auth.auth().currentUser else { return }
//        currentUser.getTokenForcingRefresh(true) { (idToken, error) in
//            if let error = error {
//                completion(false, error as NSError?)
//                print(error.localizedDescription)
//            } else {
//                completion(true, nil)
//            }
//        }
//    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        configureInitialRootViewController(for: window!)
//       
//        let storyboard = UIStoryboard(name: "LogInStoryBoard", bundle: .main)
//        if let initialViewController = storyboard.instantiateInitialViewController() {
//        window?.rootViewController = initialViewController
//        window?.makeKeyAndVisible()
//        }
//       
        
        GMSServices.provideAPIKey("AIzaSyBUG325imlLGazifftWDvmEb3E_AxXJlSo")
        GMSPlacesClient.provideAPIKey("AIzaSyBUG325imlLGazifftWDvmEb3E_AxXJlSo")
                
        
        return true
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate {
    func configureInitialRootViewController(for window: UIWindow) {
    let defaults = UserDefaults.standard
        let initialViewController: UIViewController
        
        if Auth.auth().currentUser != nil,
            let userData = defaults.object(forKey: "currentUser") as? Data,
            let user = NSKeyedUnarchiver.unarchiveObject(with: userData) as? HardCodedUsers {
                HardCodedUsers.setCurrent(user)
                initialViewController = UIStoryboard.initialViewController(for: .main)
        }
        else {
            let storyboard = UIStoryboard(name: "LogInStoryBoard", bundle: .main)
            guard let controller = storyboard.instantiateInitialViewController() else {
                fatalError()
            }
            initialViewController = controller
        }
        
        window.rootViewController = initialViewController
        window.makeKeyAndVisible()
        
    }

}
