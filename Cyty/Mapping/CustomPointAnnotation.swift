//
//  CustomPointAnnotation.swift
//  Cyty
//
//  Created by Benjamin Hakes on 2/6/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit
import MapKit

class CustomPointAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var jobID: String
    var pinCustomImageName: String? = ""
    var title: String? = ""
    var subtitle: String? = ""
    
    init (coordinate: CLLocationCoordinate2D, jobID: String){
        self.coordinate = coordinate
        self.jobID = jobID
    }
}

class CustomAnnotationView: MKAnnotationView{
    var jobID: String?
    
}

