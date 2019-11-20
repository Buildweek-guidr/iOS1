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
    @IBOutlet weak var descriptionTextField: UITextField!
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
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        guard let trip = trip else { return }
        
    }
    
    

}

