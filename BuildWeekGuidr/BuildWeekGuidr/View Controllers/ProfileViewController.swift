//
//  ProfileViewController.swift
//  BuildWeekGuidr
//
//  Created by morse on 11/17/19.
//  Copyright © 2019 morse. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    
    // MARK: - Properties
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    }
    
    // MARK: - Actions
    
    @IBAction func logOut(_ sender: Any) {
        
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        let context = CoreDataStack.shared.mainContext
        do {
            let profiles = try context.fetch(fetchRequest)
            
            for profile in profiles {
                context.delete(profile)
                try? CoreDataStack.shared.save(context: context)
            }
        } catch {
            print("Could not log out!")
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    private func updateView() {
        profileImageView.layer.cornerRadius = (profileImageView.bounds.size.width - 1) / 2
        profileImageView.layer.cornerCurve = .circular
        profileImageView.layer.borderWidth = 4
        profileImageView.layer.borderColor = UIColor(displayP3Red: 28/255.0, green: 28/255.0, blue: 30/255.0, alpha: 1.0).cgColor
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
