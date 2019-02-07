//
//  JobRequestStatus.swift
//  Cyty
//
//  Created by Benjamin Hakes on 2/6/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation

enum JobRequestStatus: String, Codable {
    case Requested
    case Accepted
    case Fulfilled
}
