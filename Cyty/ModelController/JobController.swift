//
//  JobController.swift
//  Cyty
//
//  Created by Benjamin Hakes on 2/5/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://new-project-69d95.firebaseio.com/")!

class JobController {
    
    func createJobRequest(for jobRequest: JobRequest) {
        
        put(jobRequest: jobRequest)
        saveToPersistentStore()
    }
    
    func deleteJobRequest(for jobRequest: JobRequest) {
        
        CoreDataStack.shared.mainContext.delete(jobRequest)
        deleteEntryFromServer(jobRequest: jobRequest)
        saveToPersistentStore()
    }
    
    
    private func put(jobRequest: JobRequest, completion: @escaping ((Error?) -> Void) = { _ in }) {
        
        let jobID = jobRequest.jobID?.uuidString ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent("JobRequest").appendingPathComponent(jobID).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(jobRequest)
        } catch {
            NSLog("Error encoding Entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTting Entry to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
    }
    
    
    func deleteEntryFromServer(jobRequest: JobRequest, completion: @escaping ((Error?) -> Void) = { _ in }) {
        
        guard let jobID = jobRequest.jobID else {
            NSLog("JobID is nil")
            completion(NSError())
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("JobRequest").appendingPathComponent(jobID.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error deleting entry from server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
    }
    
    func fetchJobRequestsFromServer(for fetchType: FetchType, with userID: UUID, completion: @escaping (([JobRepresentation]?, Error?) -> Void) = { _,_ in }) {

        // build the filtered endpoint request
        
        let urlComponents = createURLComponents(for: fetchType, with: userID)
    
        guard let requestURL = urlComponents.url else {
            print("Error forming URL")
            return
        }
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in

            if let error = error {
                NSLog("Error fetching entries from server: \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(nil, NSError())
                return
            }

            do {
                let jobRepresentations = try JSONDecoder().decode([String: JobRepresentation].self, from: data).map({$0.value})
                completion(jobRepresentations, nil)
            } catch {
                NSLog("Error decoding JSON data: \(error)")
                completion(nil, error)
                return
            }
            }.resume()
    }

    
    func refreshJobsFromServer(with userID: UUID,completion: @escaping ((Error?) -> Void) = { _ in }) {
        fetchJobRequestsFromServer(for: .JobsRequestedByUser, with: userID) { (representations, error) in
            if error != nil { return }
            guard let representations = representations else { return }
            let moc = CoreDataStack.shared.container.newBackgroundContext()
            self.updateJobRequests(with: representations, in: moc, completion: completion)
        }
    }

    private func updateJobRequests(with jobRepresentations: [JobRepresentation],
                               in context: NSManagedObjectContext,
                               completion: @escaping ((Error?) -> Void) = { _ in }) {

        importer = CoreDataImporter(context: context)
        importer?.sync(jobRepresentations: jobRepresentations) { (error) in
            if let error = error {
                NSLog("Error syncing entries from server: \(error)")
                completion(error)
                return
            }

            context.perform {
                do {
                    try context.save()
                    completion(nil)
                } catch {
                    NSLog("Error saving sync context: \(error)")
                    completion(error)
                    return
                }
            }
        }
    }
    
    func createURLComponents(for fetchType: FetchType, with userID: UUID) -> URLComponents{
        switch fetchType {
        case .JobsRequestedByUser :
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "new-project-69d95.firebaseio.com"
            urlComponents.path = "/JobRequest/.json"
            
            urlComponents.queryItems = [
                URLQueryItem(name: "orderBy", value: "\"requesterID\""),
                URLQueryItem(name: "equalTo", value: "\"\(userID.uuidString)\"")
            ]
            return urlComponents
        
        case .JobsAvailableForUser :
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "new-project-69d95.firebaseio.com"
            urlComponents.path = "/JobRequest/.json"
            
            return urlComponents
        }
        
        
        
    }
    
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    private var importer: CoreDataImporter?
}

enum FetchType: String, Codable {
    case JobsRequestedByUser
    case JobsAvailableForUser
}
