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
    @IBOutlet weak var specialtyTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var experienceTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var taglineTextField: UITextField!
    @IBOutlet weak var specialtyLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    // MARK: - Properties
    
    var profile: Profile?
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateProfile()
        updateViews()
    }
    
    // MARK: - Actions
    
    @IBAction func logOut(_ sender: Any) {
        
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        let context = CoreDataStack.shared.mainContext
        do {
            let profiles = try context.fetch(fetchRequest)
            
            for profile in profiles {
                context.delete(profile)
            }
            try CoreDataStack.shared.save(context: context)
            print("Logged out")
        } catch {
            print("Could not log out!")
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    private func updateViews() {
        updateUI()
        guard let profile = profile else { return }
        titleLabel.text = profile.title
        taglineLabel.text = profile.tagline
        specialtyLabel.text = profile.guideSpecialty
        ageLabel.text = String(profile.age)
        experienceLabel.text = String(profile.yearsExperience)
    }
    
    func updateProfile() {
        guard let profile = profile else { return }
    }
    
    func updateUI() {
        
        titleLabel.isHidden = true
        taglineLabel.isHidden = true
        specialtyLabel.isHidden = true
        ageLabel.isHidden = true
        experienceLabel.isHidden = true
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
