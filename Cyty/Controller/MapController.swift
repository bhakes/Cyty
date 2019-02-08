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
    
    init(mapView: MKMapView){
        self.mapView = mapView
    }
    
    func openMapToUserLocation(mapView: MKMapView, userLocation: CLLocationCoordinate2D?) {
        
        guard let userLocation = userLocation else { return }
        // put latitude, longitude into variables
        let (latitude, longitude) = (userLocation.latitude, userLocation.longitude)
        
        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
        let regionRadius: CLLocationDistance = 1000
        
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true
        mapView.isZoomEnabled = true
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        
        centerMapOnLocation(mapView: mapView, location: initialLocation, regionRadius: regionRadius)
    }
    
    // center passed map on a given location

    func centerMapOnLocation(mapView: MKMapView, location: CLLocation, regionRadius: Double) {
        
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    func addJobLocationsToMap(jobRepresentations: [JobRepresentation]?) -> MKMapView {
        
        // unwrap the map
        guard let mapView = mapView else {
            print("Did not safely unwrap the map")
            fatalError("No MapView to Return")
        }
        
        guard let jobRepresentations = jobRepresentations else {
            return mapView
        }
        
        for job in jobRepresentations {
            
            guard let jobID = job.jobID?.uuidString else  { fatalError("could not create job requests from job")}
            
            let (lat, long, bounty) = (job.latitude, job.longitude, job.bounty)
            let annotation = CustomPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long), jobID: jobID)
            
            annotation.title = String(bounty)
            annotation.subtitle = job.title
            
            switch bounty {
            case 0..<8:
                annotation.pinCustomImageName = "pin-red-30p"
            case 10..<15:
                annotation.pinCustomImageName = "pin-yellow-30p"
            case _ where bounty > 15:
                annotation.pinCustomImageName = "pin-green-30p"
            default:
                annotation.pinCustomImageName = "pin-green-30p"
            }
            
            mapView.addAnnotation(annotation)
        }
        
        mapView.showAnnotations(mapView.annotations, animated: true)
    
        return mapView
        
    }
    
    // MARK: - Properties
    var mapView: MKMapView?
    
}


