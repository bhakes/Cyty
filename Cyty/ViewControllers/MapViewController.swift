//
//  MapViewController.swift
//  Cyty
//
//  Created by Benjamin Hakes on 2/4/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
        mapController = MapController(mapView: mapView)
        user = User(firstName: "Bob", lastName: "Smith", email: "bob@aol.com")
        currentLocationPin = MKPointAnnotation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    // MARK: - Core Location Manager
    
    func getLocation() {
        
        let status  = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationMgr.requestWhenInUseAuthorization()
            return
        }
        
        if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        locationMgr.delegate = self
        locationMgr.startUpdatingLocation()
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        let currentLocation = locations.last! as CLLocation
//
//        currentLocationPin?.coordinate = currentLocation.coordinate
//        mapView.addAnnotation(currentLocationPin!)
//
//    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }

    // MARK: Refresh
    
    private func refresh() {
        guard let userID = user?.userID else {fatalError("Could not get user's id")}
        
        jobController.fetchJobRequestsFromServer(for: .JobsAvailableForUser, with: userID) { (representations, error) in
            
            guard let representations = representations else { return }
            
            for jobRep in representations {
                
                self.jobRepresentations.append(jobRep)
                
            }
            DispatchQueue.main.async {
                self.mapView = self.mapController?.addJobLocationsToMap(jobRepresentations: self.jobRepresentations)
                self.mapController?.openMapToUserLocation(mapView: self.mapView, userLocation: self.locationMgr.location?.coordinate)
            }
            
        }
    }
    
    // MapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return MKAnnotationView()
        }
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
        
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinView!.canShowCallout = true
            //Set your image here
            pinView!.image = UIImage(named: "mappin")
            
            var calloutButton = UIButton(type: .detailDisclosure) as! UIButton
            pinView!.rightCalloutAccessoryView = calloutButton
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    var mapController: MapController?
    var currentLocationPin: MKPointAnnotation?
    let locationMgr = CLLocationManager()
    var jobRepresentations: [JobRepresentation] = []
    var jobController: JobController = JobController()
    @IBOutlet weak var mapView: MKMapView!
    var user: User?
    
    
}
