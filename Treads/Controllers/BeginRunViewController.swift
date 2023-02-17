//
//  BeginRunViewController.swift
//  Treads
//
//  Created by Ben Gauger on 2/14/23.
//

import UIKit
import MapKit

class BeginRunViewController: LocationViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var previousRunView: UIView!
    @IBOutlet weak var previousPaceLabel: UILabel!
    @IBOutlet weak var previousDistanceLabel: UILabel!
    @IBOutlet weak var previousDurationLabel: UILabel!
    @IBOutlet weak var lastRunButton: UIButton!
    @IBOutlet weak var previousRunStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationAuthStatus()
        mapView.delegate = self
        getLastRun()
        
        
        
//        print("here are my runs: \(RunModel.getAllRuns())")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.startUpdatingLocation()
        getLastRun()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }

    @IBAction func locationPressed(_ sender: Any) {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    func getLastRun() {
        guard let lastRun = RunModel.getAllRuns()?.first else {
            previousRunView.isHidden = true
            previousRunStack.isHidden = true
            lastRunButton.isHidden = true
            return
        }
        previousRunView.isHidden = false
        previousRunStack.isHidden = false
        lastRunButton.isHidden = false
        previousPaceLabel.text = "Pace: \(lastRun.pace.formatTimeDurationToString())/km"
        previousDistanceLabel.text = "Distance: \(lastRun.distance.metersToKilometers(places: 2)) km"
        previousDurationLabel.text = "Duration: \(lastRun.duration.formatTimeDurationToString())"
    
    }
    
    
    @IBAction func lastRunClosedPressed(_ sender: Any) {
        previousRunView.isHidden = true
        previousRunStack.isHidden = true
        lastRunButton.isHidden = true
    }
    
}


extension BeginRunViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
    }
}

