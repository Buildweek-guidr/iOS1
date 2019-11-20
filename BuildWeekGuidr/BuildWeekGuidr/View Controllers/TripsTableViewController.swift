//
//  TripsTableViewController.swift
//  BuildWeekGuidr
//
//  Created by morse on 11/17/19.
//  Copyright © 2019 morse. All rights reserved.
//

import UIKit
import CoreData

class TripsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    struct PropertyKeys {
        static let cell = "TripCell"
        
        static let addSegue = "ShowAddTripSegue"
        static let detailSegue = "ShowTripDetailSegue"
        static let profileSegue = "ShowProfileSegue"
        static let loginSegue = "ShowLoginSegue"
        
        static let date = "date"
    }
    
    let apiController = APIController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Trip> = {
        
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: PropertyKeys.date, ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: CoreDataStack.shared.mainContext,
                                             sectionNameKeyPath: nil/*PropertyKeys.date*/,
                                             cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        
        return frc
    }()
    
    // MARK: - Lifecycle Methods

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let tripsFetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
//        let context = CoreDataStack.shared.mainContext
//        do {
//            let trips = try context.fetch(tripsFetchRequest)
//            print("Tasks: \(trips.count)")
//
//
//            if trips.count > 1 {
//                for trip in trips {
//                    context.delete(trip)
//                    try? CoreDataStack.shared.save(context: context)
//                }
//            }
//        } catch {
//            print("error fetching profile")
//        }
        
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        let context = CoreDataStack.shared.mainContext
        do {
            let profiles = try context.fetch(fetchRequest)
            if profiles.count == 1 {
                // fetch trips here
                print("We have a profile! \(profiles.count)")
                apiController.fetchTrips()
            } else if profiles.count > 1 {
                for profile in profiles {
                    context.delete(profile)
                    try? CoreDataStack.shared.save(context: context)
                }
                print("Too many profiles: \(profiles.count)")
                // login here
                performSegue(withIdentifier: PropertyKeys.loginSegue, sender: self)
            } else {
                print("No profile...")
                // login here
                performSegue(withIdentifier: PropertyKeys.loginSegue, sender: self)
            }
        } catch {
            print("error fetching profile")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        tableView.reloadData()
    }
    
    @IBAction func reload(_ sender: Any) {
        viewWillAppear(true)
    }
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(fetchedResultsController.fetchedObjects?.count)

        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.cell, for: indexPath)

        cell.textLabel?.text = fetchedResultsController.object(at: indexPath).title
        cell.detailTextLabel?.text = "\(fetchedResultsController.object(at: indexPath).distance) Miles"

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let trip = fetchedResultsController.object(at: indexPath)
            
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PropertyKeys.loginSegue {
            guard let loginVC = segue.destination as? LoginViewController else { return }
            loginVC.apiController = apiController
        } else if segue.identifier == PropertyKeys.detailSegue {
            guard let detailVC = segue.destination as? TripDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.apiController = apiController
            detailVC.trip = fetchedResultsController.object(at: indexPath)
        }
    }
    

}

extension TripsTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
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
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default:
            return
        }
    }
}
