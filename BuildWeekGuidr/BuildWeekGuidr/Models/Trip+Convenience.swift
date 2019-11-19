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
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    var tripRepresentation: TripRepresentation? {
        guard let date = date,
            let image = image,
            let title = title,
            let tripType = tripType,
            let tripDescription = tripDescription else { return nil }
        
        return TripRepresentation(title: title, tripDescription: tripDescription, isPrivate: isPrivate/*boolToInt(isPrivate)*/, isProfessional: isProfessional/* boolToInt(isProfessional)*/, image: image, duration: duration, distance: distance, date: dateFormatter.string(from: date), tripType: tripType, id: Int(userId))
    }
    
    // MARK: - Initializers
    @discardableResult convenience init(date: Date,
                                        distance: Double,
                                        duration: Double,
                                        image: String,
                                        isPrivate: Bool,
                                        isProfessional: Bool,
                                        title: String,
                                        tripDescription: String,
                                        userId: Int64,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.date = date
        self.distance = distance
        self.duration = duration
        self.image = image
        self.isPrivate = isPrivate
        self.isProfessional = isProfessional
        self.title = title
        self.tripDescription = tripDescription
        self.userId = userId
    }
    
    @discardableResult convenience init?(tripRepresentation: TripRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }
        
        func intToBool(_ Int: Int) -> Bool {
            return (Int == 1 ? true : false)
        }
        
        guard let date = dateFormatter.date(from: tripRepresentation.date) else { return nil }
        
        
        self.init(date: date,
                  distance: tripRepresentation.distance,
                  duration: tripRepresentation.duration,
                  image: tripRepresentation.image,
                  isPrivate: tripRepresentation.isPrivate /*intToBool(tripRepresentation.isPrivate)*/,
            isProfessional: tripRepresentation.isProfessional /*intToBool(tripRepresentation.isProfessional)*/,
                  title: tripRepresentation.title,
                  tripDescription: tripRepresentation.tripDescription,
                  userId: Int64(tripRepresentation.id))
    }
    
    func boolToInt(_ boolean: Bool) -> Int {
        return (boolean ? 1 : 0)
    }
    
    
    
}
