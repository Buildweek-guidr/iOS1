//
//  TripDetailViewController.swift
//  BuildWeekGuidr
//
//  Created by morse on 11/17/19.
//  Copyright © 2019 morse. All rights reserved.
//

import UIKit
import CoreData

class TripDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var privateTextField: UITextField!
    @IBOutlet weak var professionalTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var privateSwitch: UISwitch!
    @IBOutlet weak var professionalSwitch: UISwitch!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var privateLabel: UILabel!
    @IBOutlet weak var professionalLabel: UILabel!
    
    // MARK: - Properties
    var trip: Trip?
    var apiController: APIController?
    var profile: Profile?
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateViews()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        guard let dateString = dateTextField.text,
            let date = dateFormatter.date(from: dateString),
            let tripType = typeTextField.text,
            !tripType.isEmpty,
            let distanceString = distanceTextField.text,
            let distance = Double(distanceString),
            let durationString = durationTextField.text,
            let duration = Double(durationString),
            let title = titleTextField.text,
            let description = descriptionTextView.text,
            !description.isEmpty,
            let profile = profile else {
                print("fail")
                return }
        print("save")
        let context = CoreDataStack.shared.mainContext
        
        if let trip = trip {
            // Editing existing task
            trip.date = date
            trip.tripType = tripType
            trip.distance = distance
            trip.tripDescription = description
            trip.isPrivate = privateSwitch.isOn ? true : false
            trip.isProfessional = professionalSwitch.isOn ? true : false
            trip.duration = duration
//            apiController//.saveAndPostFunction
        } else {
            
//            guard let userId = profile.token?.userId else { return }
            let trip = Trip(date: date, distance: distance, duration: duration, id: nil, image: "", isPrivate: privateSwitch.isOn, isProfessional: professionalSwitch.isOn, title: title, tripDescription: description/*, userId: userId*/, tripType: tripType, profile: profile, context: context)
            
            print(trip.profile?.token?.userId)
            
            guard let apiController = apiController else { return }
            apiController.saveNewTrip(trip: trip)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func setPrivate(_ sender: UISwitch) {
        
        switch sender.isOn {
        case true:
            privateTextField.text = "Private"
        case false:
            privateTextField.text = "Public"
            
        }
    }
    
    @IBAction func setProfessional(_ sender: UISwitch) {
        switch sender.isOn {
        case true:
            professionalTextField.text = "Professional"
        case false:
            professionalTextField.text = "Personal"
        }
    }
    
    
    func updateViews() {
        title = trip?.title ?? "Create a Trip"
        privateSwitch.isHidden = true
        professionalSwitch.isHidden = true
        saveButton.isHidden = true
        if let trip = trip,
            let date = trip.date,
            let tripType = trip.tripType,
            let description = trip.tripDescription {
            let distance = stringFromDistance(for: trip.distance)
            let privateText = trip.isPrivate ? "Private" : "Public"
            let professionalText = trip.isProfessional ? "Professional" : "Personal"
            
            dateTextField.text = dateFormatter.string(from: date)
            typeTextField.text = tripType
            descriptionTextView.text = description
            distanceTextField.text = distance
            privateTextField.text = privateText
            professionalTextField.text = professionalText
        } else {
            titleTextField.isHidden = false
            privateSwitch.isHidden = false
            professionalSwitch.isHidden = false
            editButton.isEnabled = false
            saveButton.isHidden = false
        }
    }
    
    
    
    
    func stringFromDistance(for distance: Double) -> String {
        if distance.rounded() == distance {
            return "\(String(Int(distance))) Miles"
        } else {
            return "\(String(distance)) Miles"
        }
    }
    
    
    
}

