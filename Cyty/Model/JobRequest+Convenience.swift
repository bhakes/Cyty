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
    convenience init(jobID: UUID = UUID(),
                     title: String,
                     jobDescription: String?,
                     bounty: Double,
                     requesterID: UUID,
                     requestTime: Date = Date(),
                     latitude: Double,
                     longitude: Double,
                     jobAcceptanceID: UUID? = nil,
                     jobFulfillmentID: UUID? = nil,
                     jobCancellationID: UUID? = nil,
                     jobVerificationID: UUID? = nil,
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
        
    }
}
