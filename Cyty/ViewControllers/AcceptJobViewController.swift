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
        guard let jobRequestString = jobRequestString else { fatalError("did not pass job request") }
        guard let uuidStringToFetch = UUID(uuidString: jobRequestString) else { fatalError("did create uuid") }
        
        jobController.fetchJobRequestsFromServer(for: .JobFromSingleUUID , with: uuidStringToFetch) { (representations, error) in
            
            guard let representations = representations else { return }
            guard let representation = representations.first else { return }
            self.jobRep = representation
         
            DispatchQueue.main.async {
                self.mapController = MapController(mapView: self.mapView)
                self.mapView = self.mapController?.addJobLocationsToMap(jobRepresentations: representations)
                 let jobRequestCoords = CLLocationCoordinate2D(latitude: representation.latitude, longitude: representation.longitude)
                
                
                self.titleTextField.text = representation.title
                self.jobTypeTextField.text = representation.jobDescription
                self.bountyTextField.text = String(representation.bounty)
                self.mapController?.openMapToUserLocation(mapView: self.mapView, userLocation: jobRequestCoords)
                
                self.mapView.delegate = self
                
                guard let currentLocationPin = self.currentLocationPin else { return }
                currentLocationPin.coordinate = jobRequestCoords
                self.mapView.addAnnotation(currentLocationPin)

            }
            
        }
        
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
    
    @IBAction func fulfillButtonClicked(_ sender: Any) {
        
        guard let title = titleTextField.text,
            let bounty = bountyTextField.text,
            let coordinates = currentLocationPin?.coordinate,
            title != "",
            bounty != "" else { return }
        
        guard let userID = user?.userID else { fatalError("Lost track of the current user") }
        jobRep?.jobFulfillmentID = userID
        jobRep?.status = JobRequestStatus.Fulfilled.rawValue
        
        let newRequest = JobRequest(title: title, jobDescription: "", bounty: Double(bounty) ?? 0.0, requesterID: userID, latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        jobController.createJobRequest(for: newRequest)
        
        titleTextField.text = ""
        navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: - Properties
    var mapController: MapController?
    let jobController: JobController = JobController()
    var jobRequestString: String?
    var jobRep: JobRepresentation?
    var user: User?
    var currentLocationPin: MKPointAnnotation?
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var jobTypeTextField: UITextField!
    @IBOutlet weak var bountyTextField: UITextField!
    var uuidStringOfJobToAccept: String?
    

}
