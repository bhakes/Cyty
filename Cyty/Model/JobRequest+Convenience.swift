//
//  JobRequest+Convenience.swift
//  Cyty
//
//  Created by Benjamin Hakes on 2/5/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation
import CoreData

extension JobRequest {
    convenience init(jobID: UUID? = UUID(),
                     title: String,
                     jobDescription: String?,
                     bounty: Double,
                     requesterID: UUID,
                     requestTime: Date? = Date(),
                     latitude: Double,
                     longitude: Double,
                     jobAcceptanceID: UUID? = nil,
                     jobFulfillmentID: UUID? = nil,
                     jobCancellationID: UUID? = nil,
                     jobVerificationID: UUID? = nil,
                     status: String? = JobRequestStatus.Requested.rawValue,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context:context)
        self.jobID = jobID
        self.title = title
        self.jobDescription = jobDescription
        self.bounty = bounty
        self.requesterID = requesterID
        self.requestTime = requestTime
        self.jobAcceptanceID = jobAcceptanceID
        self.jobFulfillmentID = jobFulfillmentID
        self.jobCancellationID = jobCancellationID
        self.jobVerificationID = jobVerificationID
        self.latitude = latitude
        self.longitude = longitude
        self.status = status
        
        
    }
    
    
    convenience init?(jobRepresentation: JobRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let requesterID = jobRepresentation.requesterID else {fatalError("failed to get rID")}
        guard let title = jobRepresentation.title else { fatalError("failed to get title") }
        
        let jobAcceptanceID = jobRepresentation.jobAcceptanceID
        let jobCancellationID = jobRepresentation.jobCancellationID
        let jobDescription = jobRepresentation.jobDescription
        let jobFulfillmentID = jobRepresentation.jobFulfillmentID
       let jobID = jobRepresentation.jobID
       let jobVerificationID = jobRepresentation.jobVerificationID
       let requestTime = jobRepresentation.requestTime

        
        let latitude = jobRepresentation.latitude
        let longitude  = jobRepresentation.longitude
        let bounty = jobRepresentation.bounty
        let status = jobRepresentation.status

        self.init(jobID: jobID, title: title, jobDescription: jobDescription, bounty: bounty, requesterID: requesterID, requestTime: requestTime, latitude: latitude, longitude: longitude, jobAcceptanceID: jobAcceptanceID, jobFulfillmentID: jobFulfillmentID, jobCancellationID: jobCancellationID, jobVerificationID: jobVerificationID, status: status)
    }
    
}

enum JobRequestStatus: String, Codable {
    case Requested
    case Accepted
    case Fulfilled
}
