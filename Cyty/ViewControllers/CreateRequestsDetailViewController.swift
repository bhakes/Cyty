//
//  CreateRequestsDetailViewController.swift
//  Cyty
//
//  Created by Benjamin Hakes on 2/5/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit
import MapKit

class CreateRequestsDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.mapController = MapController(mapView: self.mapView, jobLocations: nil)
        self.mapController?.openMapToUserLocation(mapView: mapView, userLocation: currentLocationPin?.coordinate)
        
        mapView.delegate = self
        
        guard let currentLocationPin = currentLocationPin else { return }
        mapView.addAnnotation(currentLocationPin)
        user = User(firstName: "Bob", lastName: "Smith", email: "bob@aol.com")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setViewForSubmitButton()
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
    
    // MARK: - Layout Methods
    
    func setViewForSubmitButton() {
        submitButton.layer.cornerRadius = 24
        
    }
    
    // MARK: - @IBAction Methods
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        
        guard let title = titleTextField.text,
            let bounty = bountyTextField.text,
            let coordinates = currentLocationPin?.coordinate,
            title != "",
            bounty != "" else { return }
       
        guard let userID = user?.userID else { fatalError("Lost track of the current user") }
        
        let newRequest = JobRequest(title: title, jobDescription: jobDescriptionTextView.text, bounty: Double(bounty) ?? 0.0, requesterID: userID, latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        jobController.createJobRequest(for: newRequest)
        
        
        titleTextField.text = ""
        navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: - Properties
    var mapController: MapController?
    let jobController: JobController = JobController()
    var user: User?
    var currentLocationPin: MKPointAnnotation?
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    @IBOutlet weak var jobTypeTextField: UITextField!
    @IBOutlet weak var bountyTextField: UITextField!
    
}
