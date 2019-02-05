//
//  CreateReqestsDetailViewController.swift
//  Cyty
//
//  Created by Benjamin Hakes on 2/5/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit
import MapKit

class CreateReqestsDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Properties
    var mapController: MapController?
    var currentLocationPin: MKPointAnnotation?
    @IBOutlet weak var mapView: MKMapView!

}
