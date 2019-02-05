//
//  JobLocations.swift
//  Cyty
//
//  Created by Benjamin Hakes on 2/4/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//


struct JobLocations: Codable {
    // Example of Array of Codable
    var features:  [Feature]
    
    struct Feature: Codable {
        var type: String
        var properties: Properties
        var geometry: Geometry
        
        struct Properties: Codable {
            
        }

        struct Geometry: Codable {
            var type: String
            var coordinates: [Double]
        }
        
        
    }
    
    var type: String
    
}

