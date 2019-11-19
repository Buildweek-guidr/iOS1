//
//  Trip+Convenience.swift
//  BuildWeekGuidr
//
//  Created by morse on 11/18/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation
import CoreData

extension Trip {
    
    // MARK: - Properties
    
    
    
    
    // MARK: - Initializers
    @discardableResult convenience init(date: Date, distance: Double, duration: Double, image: String, isPrivate: Bool, isProfessional: Bool, title: String, tripDescription: String, insertInto context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.date = date
        self.distance = distance
        self.duration = duration
        self.image = image
        self.isPrivate = isPrivate
        self.isProfessional = isProfessional
        self.title = title
        self.tripDescription = tripDescription
    }
    
    
}
