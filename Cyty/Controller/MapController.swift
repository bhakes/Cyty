//
//  MapController.swift
//  Cyty
//
//  Created by Benjamin Hakes on 2/4/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class MapController {
    
    init(mapView: MKMapView, jobLocations: JobLocations?){
        self.mapView = mapView
    }
    
    func openMapToUserLocation(mapView: MKMapView, userLocation: CLLocationCoordinate2D?) {
        
        // set initial location in Honolulu
        var latitude: CLLocationDegrees, longitude: CLLocationDegrees
        if let userLocation = userLocation {
            (latitude,longitude) = (userLocation.latitude, userLocation.longitude)
        } else {
            (latitude,longitude)  = (44.986656,-93.258133)
        }
        
        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
        let regionRadius: CLLocationDistance = 1000
        
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true
        mapView.isZoomEnabled = true
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                      latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: false)
        }
        centerMapOnLocation(location: initialLocation)
    }
    
    func addJobLocationsToMap(jobLocations: JobLocations?) -> MKMapView {
        
        // unwrap the map
        guard let mapView = mapView else {
            print("Did not safely unwrap the map")
            fatalError("No MapView to Return")
        }
        guard let mapJobs = jobLocations?.features else {
            print("No jobs to map")
            return mapView
        }
        
        for job in mapJobs {
            let annotation = MKPointAnnotation()
            let lat = job.geometry.coordinates[1]
            let long = job.geometry.coordinates[0]
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            mapView.addAnnotation(annotation)
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
        
        return mapView
        
    }
    
    // MARK: - Properties
    var mapView: MKMapView?
    
    
    
}
