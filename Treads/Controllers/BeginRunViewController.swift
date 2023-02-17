//
//  BeginRunViewController.swift
//  Treads
//
//  Created by Ben Gauger on 2/14/23.
//

import UIKit
import MapKit
import RealmSwift

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
//        print("\(RunModel.getAllRuns()?.first)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.delegate = self
        manager?.delegate = self
        manager?.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpMapView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    func centerMapOnLocation() {
        mapView.userTrackingMode = .follow
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    func centerMapOnPreviousRoute(locations: List<Location>) -> MKCoordinateRegion {
        guard let initialLocation = locations.first else {return MKCoordinateRegion()}
        var minLat = initialLocation.latitude
        var minLong = initialLocation.longitude
        var maxLat = minLat
        var maxLong = minLong
        
        for location in locations {
            minLat = min(minLat, location.latitude)
            minLong = min(minLong, location.longitude)
            maxLat = max(maxLat, location.latitude)
            maxLong = max(maxLong, location.longitude)
        }
        
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLong + maxLong) / 2), span: MKCoordinateSpan(latitudeDelta: (maxLat-minLat) * 1.5, longitudeDelta: (maxLong-minLong) * 1.5))
        
    }

    @IBAction func locationPressed(_ sender: Any) {
        centerMapOnLocation()
        
    }
    
    func setUpMapView() {
        if let overlay = addLastRunToMap() {
            if mapView.overlays.count > 0 {
                mapView.removeOverlays(mapView.overlays)
            }
            mapView.addOverlay(overlay)
            previousRunView.isHidden = false
            previousRunStack.isHidden = false
            lastRunButton.isHidden = false
        }else {
            previousRunView.isHidden = true
            previousRunStack.isHidden = true
            lastRunButton.isHidden = true
            centerMapOnLocation()
        }
        
    }
    
    
    func addLastRunToMap() -> MKPolyline? {
        guard let lastRun = RunModel.getAllRuns()?.first else {return nil}
        
        previousPaceLabel.text = "Pace: \(lastRun.pace.formatTimeDurationToString())/km"
        previousDistanceLabel.text = "Distance: \(lastRun.distance.metersToKilometers(places: 2)) km"
        previousDurationLabel.text = "Duration: \(lastRun.duration.formatTimeDurationToString())"
        
        var coordinates = [CLLocationCoordinate2D]()
        for location in lastRun.locations {
            coordinates.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        }
        
        mapView.userTrackingMode = .none
        mapView.setRegion(centerMapOnPreviousRoute(locations: lastRun.locations), animated: true)
    
        return MKPolyline(coordinates: coordinates, count: lastRun.locations.count)
    }
    
    
    @IBAction func lastRunClosedPressed(_ sender: Any) {
        previousRunView.isHidden = true
        previousRunStack.isHidden = true
        lastRunButton.isHidden = true
        centerMapOnLocation()
    }
    
}


extension BeginRunViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
//            mapView.userTrackingMode = .follow
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4
        return renderer
    }
    
}

