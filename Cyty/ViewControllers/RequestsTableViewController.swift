//
//  RequestsTableViewController.swift
//  Cyty
//
//  Created by Benjamin Hakes on 2/4/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit
import CoreData

class RequestsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = User(firstName: "Bob", lastName: "Smith", email: "bob@aol.com", userID: UUID(uuidString:"CCB19A72-A4CA-4BF4-8E3F-22B195E906F7")!)
        
        refreshTable()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell", for: indexPath) as? RequestsTableViewCell else { fatalError("Unable to Dequeue cell as RequestsTableViewCell") }
        
        let jobRequest = fetchedResultsController.object(at: indexPath)
        cell.detailTextLabel?.text = "$\(jobRequest.bounty)"
        cell.textLabel?.text = jobRequest.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let jobRequest = fetchedResultsController.object(at: indexPath)
            jobController.deleteJobRequest(for: jobRequest)
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    private func refreshTable() {
        
        guard let userID = user?.userID else {fatalError("error unwrapping userID")}
        jobController.refreshJobsFromServer(fetchType: .JobFromSingleUUID, with: userID) { error in
            if let error = error {
                NSLog("Error refreshing changes from server: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Properties
    
    var user: User?
    
    let jobController = JobController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<JobRequest> = {
        
        let fetchRequest: NSFetchRequest<JobRequest> = JobRequest.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "requestTime", ascending: false)]
        
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "status", cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            print("Failed to perform fetch on Core Data")
        }
        
        return frc
    }()
}
