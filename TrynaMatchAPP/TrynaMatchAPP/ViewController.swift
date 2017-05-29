//
//  ViewController.swift
//  TrynaMatchAPP
//
//  Created by KV Ghumaan on 5/25/17.
//  Copyright © 2017 KV Ghumaan. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import MapKit
import CoreLocation
import Foundation


class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    var locationManager: CLLocationManager!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFacebookButton()
        setUpGoogleButton()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }

        // MAP
        
        let Map = CLLocationCoordinate2DMake(<#T##latitude: CLLocationDegrees##CLLocationDegrees#>, <#T##longitude: CLLocationDegrees##CLLocationDegrees#>)
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.map.setRegion(region, animated: true)
    }
    
    fileprivate func setUpFacebookButton() {
        // FB Login Button
        
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
    }
    
    fileprivate func setUpGoogleButton() {
        // Google Login Button
        
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of Facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error)
            return
        }
        
        showEmailAddress()
    }
    
    func showEmailAddress() {
        
        let accessToken = FBSDKAccessToken.current()
        
        guard let accessTokenString = accessToken?.tokenString else {
            return
        }
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil{
                print("Something went wrong with our FB user: ", error ??
                "")
            }
            print("Succesfully logged in with our user:", user ?? "")
        })
     
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            
            if err != nil{
                
                print("Failed to start graph request:", err ?? "")
                return
            }
            
            print(result ?? "")
        }
        
    }
}

