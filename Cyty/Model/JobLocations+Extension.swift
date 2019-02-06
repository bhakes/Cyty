//
//  JobLocations+Extension.swift
//  Cyty
//
//  Created by Benjamin Hakes on 2/4/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//
import Foundation
import UIKit

extension JobLocations {
    
    static func fetch(_ completionBlock: @escaping ((JobLocations?, Error?)->())) {
        
        
//        guard let path = Bundle.main.path(forResource: "SampleGeoJSON", ofType: ".geojson") else { fatalError("No file located at that path.") }
//        let url = URL(fileURLWithPath: path)
//
//        DispatchQueue.global().async {
//            do {
//                let geoJSONData = try Data(contentsOf: url)
//                let decoder = JSONDecoder()
//                let geoJSONContainer = try decoder.decode(JobLocations.self, from: geoJSONData)
//                let geoJSON = geoJSONContainer
//                DispatchQueue.main.async {
//                    completionBlock(geoJSON, nil)
//                }
//            }
//            catch let error {
//                print("Error fetching data: \(error.localizedDescription)")
//                DispatchQueue.main.async {
//                    completionBlock(nil, error)
//                }
//            }
//        }
    }
}
