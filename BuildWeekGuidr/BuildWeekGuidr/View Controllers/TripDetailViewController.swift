//
//  TripDetailViewController.swift
//  BuildWeekGuidr
//
//  Created by morse on 11/17/19.
//  Copyright © 2019 morse. All rights reserved.
//

import UIKit

class TripDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var privateTextField: UITextField!
    @IBOutlet weak var professionalTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var distanceTextField: UITextField!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var privateLabel: UILabel!
    @IBOutlet weak var professionalLabel: UILabel!
    
    // MARK: - Properties
    var trip: Trip?
    var apiController: APIController?
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
    
    func updateViews() {
        guard let trip = trip,
            let date = trip.date,
            let tripType = trip.tripType,
            let description = trip.tripDescription else { return }
        
        let distance = stringFromDistance(for: trip.distance)
        let privateText = trip.isPrivate ? "Private" : "Public"
        let professionalText = trip.isProfessional ? "Professional" : "Personal"

        dateTextField.text = dateFormatter.string(from: date)
        typeTextField.text = tripType
        descriptionTextView.text = description
        distanceTextField.text = distance
        privateTextField.text = privateText
        professionalTextField.text = professionalText
    }
    
    func stringFromDistance(for distance: Double) -> String {
        if distance.rounded() == distance {
            return "\(String(Int(distance))) Miles"
        } else {
            return "\(String(distance)) Miles"
        }
    }
    
    

}

