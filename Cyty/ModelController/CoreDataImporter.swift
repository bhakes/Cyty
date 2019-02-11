//
//  CoreDataImporter.swift
//  Cyty
//
//  Created by Benjamin Hakes on 2/5/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation
import CoreData

class CoreDataImporter {
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func sync(jobRepresentations: [JobRepresentation], completion: @escaping (Error?) -> Void = { _ in }) {
        
        self.context.perform {
            
            let fetchRequest: NSFetchRequest<JobRequest> = JobRequest.fetchRequest() // create an Entry NSFetchRequest
            var result: [JobRequest]? = nil // create an entry array named 'result' that will store the entries you find in the Persistent Store
            
            do { // in the current (background) context, perform the fetch request from the persistent store
                result = try self.context.fetch(fetchRequest) // assign the (error-throwing) fetch request, done on the background context, to result
            } catch {
                NSLog("Error fetching list of JobRequests: \(error)") // if the fetch request throws an error, NSLog it
            }
            
            // we now need to check to see that we have results back
            // if we do, let's create a dictionary to put those results in
            
            if let alreadyInCoreDataJobRequests = result {
                var coreDataDictionary: [String: JobRequest] = [:] // if there is already a list of arrays in core data, make a dictionary
                
                for existingJobRequest in alreadyInCoreDataJobRequests {
                    guard let jobID = existingJobRequest.jobID?.uuidString else { return }
                    coreDataDictionary[jobID] = existingJobRequest
                }
                
                for jobRep in jobRepresentations {
                    guard let jobID = jobRep.jobID?.uuidString else { return }
                    
                    
                    if let jobRequest = coreDataDictionary[jobID], jobRequest != jobRep {
                        self.update(jobRequest: jobRequest, with: jobRep)
                    } else if coreDataDictionary[jobID] == nil {
                        _ = JobRequest(jobRepresentation: jobRep, context: self.context)
                    }
                    
                }
                
            } else {
                // the fetch request returned no results, meaning there was nothing in core data,
                // meaning all we have to do is just create new entries from each entry representation
                
                for jobRep in jobRepresentations {
                    _ = JobRequest(jobRepresentation: jobRep, context: self.context)
                }
                
            }
            
            completion(nil)
        }
    }
    
    private func update(jobRequest: JobRequest, with jobRep: JobRepresentation) {
        jobRequest.bounty = jobRep.bounty
        jobRequest.jobAcceptanceID = jobRep.jobAcceptanceID
        jobRequest.jobCancellationID = jobRep.jobCancellationID
        jobRequest.jobDescription = jobRep.jobDescription
        jobRequest.jobFulfillmentID = jobRep.jobFulfillmentID
        jobRequest.jobID = jobRep.jobID
        jobRequest.jobVerificationID = jobRep.jobVerificationID
        jobRequest.latitude = jobRep.latitude
        jobRequest.longitude = jobRep.longitude
        jobRequest.requesterID = jobRep.requesterID
        jobRequest.requestTime = jobRep.requestTime
        jobRequest.title = jobRep.title
        jobRequest.status = jobRep.status
    }
    
    let context: NSManagedObjectContext
}
