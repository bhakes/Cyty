//
//  JobRepresentation.swift
//  Cyty
//
//  Created by Benjamin Hakes on 2/5/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation

struct JobRepresentation: Decodable {
    var  bounty: Double
    var  jobAcceptanceID: UUID?
    var  jobCancellationID: UUID?
    var  jobDescription: String?
    var  jobFulfillmentID: UUID?
    var  jobID: UUID?
    var  jobVerificationID: UUID?
    var  latitude: Double
    var  longitude: Double
    var  requesterID: UUID?
    var  requestTime: Date?
    var  title: String?

}

func ==(lhs: JobRepresentation, rhs: JobRequest) -> Bool {
    return rhs.title == lhs.title &&
        rhs.bounty == lhs.bounty &&
        rhs.requesterID == lhs.requesterID &&
        rhs.requestTime == lhs.requestTime &&
        rhs.jobID == lhs.jobID
}

func ==(lhs: JobRequest, rhs: JobRepresentation) -> Bool {
    return rhs == lhs
}

func !=(lhs: JobRepresentation, rhs: JobRequest) -> Bool {
    return !(lhs == rhs)
}

func !=(lhs: JobRequest, rhs: JobRepresentation) -> Bool {
    return rhs != lhs
}
