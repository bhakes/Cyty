//
//  CreateRequestMapViewController.swift
//  Cyty
//
//  Created by Benjamin Hakes on 2/5/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CreateRequestMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLocation()
        self.mapController = MapController(mapView: self.mapView, jobLocations: nil)
        self.mapController?.openMapToUserLocation(mapView: self.mapView, userLocation: locationMgr.location?.coordinate)
        mapView.delegate = self
        
        let gestureRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(addPin(gestureRecognizer:)))
        gestureRecognizer.numberOfTouchesRequired = 1
        mapView.addGestureRecognizer(gestureRecognizer)
        
        user = User(firstName: "Bob", lastName: "Smith", email: "bob@aol.com", userID: UUID(uuidString:"CCB19A72-A4CA-4BF4-8E3F-22B195E906F7")!)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setViewForCreateButton()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        guard let destination = segue.destination as? CreateRequestsDetailViewController
            else { return }
        
        destination.currentLocationPin = currentLocationPin
        
        
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation = locations.last! as CLLocation
        
        currentLocationPin = MKPointAnnotation()

        currentLocationPin?.coordinate = currentLocation.coordinate
        mapView.addAnnotation(currentLocationPin!)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    // MARK: - Movable Pin Methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let currentLocationPin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "currentLocationPin")
            
            currentLocationPin.pinTintColor = .purple
            currentLocationPin.isDraggable = true
            currentLocationPin.canShowCallout = true
            currentLocationPin.animatesDrop = true
            
            return currentLocationPin
        }
        
        return nil
    }
    
    @objc func addPin(gestureRecognizer: UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        guard var currentLocationPin = currentLocationPin else {
            print("Nothing in current location")
            return
        }

        currentLocationPin.coordinate = newCoordinates
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            currentLocationPin = MKPointAnnotation()
            currentLocationPin.coordinate = newCoordinates
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotation(currentLocationPin)
        } else if gestureRecognizer.state == UIGestureRecognizer.State.ended {
            return
        }
    }
    
    // MARK: - Layout Methods
    
    func setViewForCreateButton() {
        createButton.layer.cornerRadius = 24
        viewForCreateButton.layer.cornerRadius = 24
    }
    
    // MARK: - @IBAction Methods
    
    @IBAction func createButtonPressed(_ sender: Any) {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    var mapController: MapController?
    var jobLocations: JobLocations?
    var currentLocationPin: MKPointAnnotation?
    @IBOutlet weak var mapView: MKMapView!
    let locationMgr = CLLocationManager()
    
    @IBOutlet weak var viewForCreateButton: UIView!
    @IBOutlet weak var createButton: UIButton!
    var user: User?

    
}
