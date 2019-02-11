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
        user = User(firstName: "Bob", lastName: "Smith", email: "bob@aol.com", userID: UUID(uuidString:"CCB19A72-A4CA-4BF4-8E3F-22B195E906F7")!)
        
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
                self.mapView.removeAnnotations(self.mapView.annotations)
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
        guard let destVC = segue.destination as? AcceptJobViewController else {fatalError("Segue should be going to AcceptJob VC but is not")}
        
        destVC.jobRequestString = jobRequestStringToSegue
        destVC.currentLocationPin = MKPointAnnotation()
        
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
    var jobRequestStringToSegue: String?
    
}

extension MapViewController {
    
    //MARK: - Custom Annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseIdentifier = "pin"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? CustomAnnotationView
        
        if annotation is MKUserLocation {
            return nil
        }
        
        if annotationView == nil {
            annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        if let customPointAnnotation = annotation as? CustomPointAnnotation {
    
            guard let pinCustomImageName = customPointAnnotation.pinCustomImageName else {
                fatalError("Error getting pinCustomImageName")
            }
            annotationView?.annotation = customPointAnnotation
            annotationView?.image = UIImage(named: pinCustomImageName)
            annotationView?.canShowCallout = true
            annotationView?.jobID = customPointAnnotation.jobID
            let button = UIButton(type: .contactAdd)
            annotationView?.rightCalloutAccessoryView = button
        }
       
        return annotationView
        
    }
    
    // When user taps on the disclosure button you can perform a segue to navigate to another view controller
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let view = view as? CustomAnnotationView else {fatalError("couldn't get custom animation")}
        if control == view.rightCalloutAccessoryView {
            jobRequestStringToSegue = view.jobID
            performSegue(withIdentifier: "acceptJobViewController", sender: self)
            
        }
        
        
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {

        let imageView = UIImageView.init(frame: CGRect(origin: CGPoint(x:0, y:0), size: CGSize(width: 30.0, height: 30.0)))
        imageView.image = UIImage(named: "create_new")
        view.leftCalloutAccessoryView = imageView
        
    }
    
    
}
