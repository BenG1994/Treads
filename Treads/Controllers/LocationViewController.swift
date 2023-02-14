//
//  LocationViewController.swift
//  Treads
//
//  Created by Ben Gauger on 2/14/23.
//

import UIKit
import MapKit

class LocationViewController: UIViewController, MKMapViewDelegate {
    
    var manager: CLLocationManager?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        manager = CLLocationManager()
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.activityType = .fitness
    }
    
    func checkLocationAuthStatus() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            manager?.requestWhenInUseAuthorization()
        }
    
    }

}
