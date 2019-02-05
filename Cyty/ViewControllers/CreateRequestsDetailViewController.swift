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
        setViewForSubmitButton()
        guard let currentLocationPin = currentLocationPin else { return }
        mapView.addAnnotation(currentLocationPin)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
        print("submit to job to server")
        
    }
    

    
    // MARK: - Properties
    var mapController: MapController?
    var currentLocationPin: MKPointAnnotation?
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
}
