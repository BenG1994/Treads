//
//  CurrentRunViewController.swift
//  Treads
//
//  Created by Ben Gauger on 2/14/23.
//

import UIKit
import RealmSwift
import MapKit

class CurrentRunViewController: LocationViewController {

    @IBOutlet weak var sliderBackgroundImageView: UIImageView!
    @IBOutlet weak var sliderImageView: UIImageView!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var pauseButton: UIButton!
    
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var coordinateLocations = List<Location>()
    
    var runDistance = 0.0
    var counter = 0
    var timer = Timer()
    var pace = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwiped(sender:)))
        sliderImageView.addGestureRecognizer(swipeGesture)
        sliderImageView.isUserInteractionEnabled = true
        swipeGesture.delegate = self as? UIGestureRecognizerDelegate
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.distanceFilter = 10
        startRun()
    }
    
    func startRun() {
        manager?.startUpdatingLocation()
        startTimer()
        pauseButton.setImage(UIImage(named: "pauseButton"), for: .normal)
    }
    
    func endRun() {
        manager?.stopUpdatingLocation()
//        add object to realm
        RunModel.addRunToRealm(pace: pace, distance: runDistance, duration: counter, locations: coordinateLocations)
        
    }
    
    func pauseRun() {
        startLocation = nil
        lastLocation = nil
        manager?.stopUpdatingLocation()
        timer.invalidate()
        pauseButton.setImage(UIImage(named: "resumeButton"), for: .normal)
        
    }
    
    func startTimer() {
        durationLabel.text = counter.formatTimeDurationToString()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        counter += 1
        durationLabel.text = counter.formatTimeDurationToString()
    }
    
    func calculatePace(time seconds: Int, km: Double) -> String {
        pace = Int(Double(seconds) / km)
        return pace.formatTimeDurationToString()
    }

    @IBAction func pauseButtonPressed(_ sender: Any) {
        if timer.isValid {
            pauseRun()
        }else {
            startRun()
        }
    }
    
    
    @objc func endRunSwiped(sender: UIPanGestureRecognizer) {
        let minAdjust: CGFloat = 78
        let maxAdjust: CGFloat = 128
        if let sliderView = sender.view {
            if sender.state == UIGestureRecognizer.State.began || sender.state == UIGestureRecognizer.State.changed {
                let translation = sender.translation(in: self.view)
                if sliderView.center.x >= (sliderBackgroundImageView.center.x - minAdjust) && sliderView.center.x <= (sliderBackgroundImageView.center.x + maxAdjust) {
                    sliderView.center = CGPoint(x: sliderView.center.x + translation.x, y: sliderView.center.y)
                }else if sliderView.center.x >= (sliderBackgroundImageView.center.x + maxAdjust) {
                    sliderView.center.x = sliderBackgroundImageView.center.x + maxAdjust
                    endRun()
                    dismiss(animated: true)
                }else {
                    sliderView.center.x = sliderBackgroundImageView.center.x - minAdjust
                }
                sender.setTranslation(CGPoint.zero, in: self.view)
            }else if sender.state == UIGestureRecognizer.State.ended {
                UIView.animate(withDuration: 0.1) {
                    sliderView.center.x = self.sliderBackgroundImageView.center.x - minAdjust
                }
            }
        }
    }
}


extension CurrentRunViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first
        }else if let location = locations.last {
            runDistance += lastLocation.distance(from: location)
            let newLocation = Location(latitude: Double(lastLocation.coordinate.latitude), longitude: Double(lastLocation.coordinate.longitude))
            coordinateLocations.insert(newLocation, at: 0)
            distanceLabel.text = String(format: "%.2f", (runDistance / 1000))
            if counter > 0 && runDistance > 0 {
                paceLabel.text = calculatePace(time: counter, km: runDistance.metersToKilometers(places: 2))
            }
        }
        lastLocation = locations.last
    }
}
