//
//  MapViewController.swift
//  Cyty
//
//  Created by Benjamin Hakes on 2/4/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        user = User(firstName: "Bob", lastName: "Smith", email: "bob@aol.com")
        guard let userID = user?.userID else {fatalError("Could not get user's id")}
            jobController.fetchJobRequestsFromServer(for: .JobsAvailableForUser, with: userID) { ([JobRepresentation]?, error) in
            self.mapView = self.mapController?.addJobLocationsToMap(jobRequests: self.jobLocations)
        }
        // Do any additional setup after loading the view.
        JobLocations.fetch { (geoJSON, error) in
            self.jobLocations = geoJSON
            self.mapController = MapController(mapView: self.mapView, jobLocations: self.jobLocations)
            
            self.mapController?.openMapToUserLocation(mapView: self.mapView, userLocation: nil)
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
    var jobController: JobController = JobController()
    var jobLocations: JobLocations?
    @IBOutlet weak var mapView: MKMapView!
    var user: User?
    
    
}
