//
//  AcceptJobViewController.swift
//  Cyty
//
//  Created by Benjamin Hakes on 2/7/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit
import MapKit

class AcceptJobViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        guard let jobRequest = jobRequest else { fatalError("did not pass job request") }
        let jobRequestCoords = CLLocationCoordinate2D(latitude: jobRequest.latitude, longitude: jobRequest.longitude)
        titleTextField.text = jobRequest.title
        jobTypeTextField.text = jobRequest.jobDescription
        bountyTextField.text = String(jobRequest.bounty)
        
        self.mapController = MapController(mapView: self.mapView)
        self.mapController?.openMapToUserLocation(mapView: mapView, userLocation: jobRequestCoords)
        
        mapView.delegate = self
        
        guard let currentLocationPin = currentLocationPin else { return }
        currentLocationPin.coordinate = jobRequestCoords
        mapView.addAnnotation(currentLocationPin)
        user = User(firstName: "Bob", lastName: "Smith", email: "bob@aol.com", userID: UUID(uuidString:"CCB19A72-A4CA-4BF4-8E3F-22B195E906F7")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setViewForSubmitButton()
    }
    
    // MARK: - Layout Methods
    
    func setViewForSubmitButton() {
        acceptButton.layer.cornerRadius = 24
        
    }
    
    // MARK: - @IBAction Methods
    
    @IBAction func acceptButtonClicked(_ sender: Any) {
        
        guard let title = titleTextField.text,
            let bounty = bountyTextField.text,
            let coordinates = currentLocationPin?.coordinate,
            title != "",
            bounty != "" else { return }
        
        guard let userID = user?.userID else { fatalError("Lost track of the current user") }
        
        let newRequest = JobRequest(title: title, jobDescription: "", bounty: Double(bounty) ?? 0.0, requesterID: userID, latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        jobController.createJobRequest(for: newRequest)
        
        titleTextField.text = ""
        navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: - Properties
    var mapController: MapController?
    let jobController: JobController = JobController()
    var jobRequest: JobRequest?
    var user: User?
    var currentLocationPin: MKPointAnnotation?
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var jobTypeTextField: UITextField!
    @IBOutlet weak var bountyTextField: UITextField!
    var uuidStringOfJobToAccept: String?
    

}
