//
//  CreateRequestsDetailViewController.swift
//  Cyty
//
//  Created by Benjamin Hakes on 2/5/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit
import MapKit

class CreateRequestsDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.mapController = MapController(mapView: self.mapView)
        self.mapController?.openMapToUserLocation(mapView: mapView, userLocation: currentLocationPin?.coordinate)
        
        self.titleTextField.delegate = self
        self.jobTypeTextField.delegate = self
        self.bountyTextField.delegate = self
        
        mapView.delegate = self
        
        guard let currentLocationPin = currentLocationPin else { return }
        mapView.addAnnotation(currentLocationPin)
        user = User(firstName: "Bob", lastName: "Smith", email: "bob@aol.com", userID: UUID(uuidString:"CCB19A72-A4CA-4BF4-8E3F-22B195E906F7")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setViewForSubmitButton()
    }

    // MARK: - Movable Pin Methods

    
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
    @IBOutlet weak var titleTextField: UITextField! {
        didSet {
                titleTextField.tag = 1
            print(titleTextField.tag)
        }
    }
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    @IBOutlet weak var jobTypeTextField: UITextField!
    @IBOutlet weak var bountyTextField: UITextField!
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        self.view.endEditing(true)
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if titleTextField.tag == 1 && titleTextField.text != "" {
            submitButton.backgroundColor = UIColor.submitColor
            submitButton.isEnabled = true
            return true
        }
        return true
    }
    
}
