//
//  JobRequest+Codable.swift
//  Cyty
//
//  Created by Benjamin Hakes on 2/5/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation

extension JobRequest: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(jobID, forKey: .jobID)
        try container.encode(title, forKey: .title)
        try container.encode(jobDescription, forKey: .jobDescription)
        try container.encode(bounty, forKey: .bounty)
        try container.encode(requesterID, forKey: .requesterID)
        try container.encode(requestTime, forKey: .requestTime)
        try container.encode(jobAcceptanceID, forKey: .jobAcceptanceID)
        try container.encode(jobFulfillmentID, forKey: .jobFulfillmentID)
        try container.encode(jobVerificationID, forKey: .jobVerificationID)
        try container.encode(jobCancellationID, forKey: .jobCancellationID)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(status, forKey: .status)
    }
    
    enum CodingKeys: String, CodingKey {
        case jobID
        case title
        case jobDescription
        case bounty
        case requesterID
        case requestTime
        case jobAcceptanceID
        case jobFulfillmentID
        case jobVerificationID
        case jobCancellationID
        case latitude
        case longitude
        case status
    }
    
}

