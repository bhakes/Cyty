//
//  SupportEnums.swift
//  Cyty
//
//  Created by Benjamin Hakes on 2/8/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation

enum FetchType: String, Codable {
    case JobsRequestedByUser
    case JobsAvailableForUser
    case JobFromSingleUUID
}

enum SupportedMarkets: String, Codable {
    case MSP = "Minneapolis-St.Paul"
    case SFO = "San Francisco Bay Area"
    case CHI = "Chicago"
    
}

enum JobRequestStatus: String, Codable {
    case Requested
    case Accepted
    case Fulfilled
}
