//
//  MapViewController.swift
//  Cyty
//
//  Created by Benjamin Hakes on 2/4/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
        mapController = MapController(mapView: mapView)
        user = User(firstName: "Bob", lastName: "Smith", email: "bob@aol.com")
        
        
        // set map view
        currentLocationPin = MKPointAnnotation()
        mapView.delegate = self
        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
    
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
    var pointAnnotation: CustomPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
    
    
    
}

extension MapViewController: MKMapViewDelegate {
    
    //MARK: - Custom Annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        if let customPointAnnotation = annotation as? CustomPointAnnotation {
        
             annotationView?.image = UIImage(named: customPointAnnotation.pinCustomImageName)
        }
       
        return annotationView
        
    }
    
}
