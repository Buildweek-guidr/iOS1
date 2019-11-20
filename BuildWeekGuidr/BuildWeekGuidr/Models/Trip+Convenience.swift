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
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter
    }
    var tripRepresentation: TripRepresentation? {
        guard let date = date,
            let image = image,
            let title = title,
            let tripType = tripType,
            let tripDescription = tripDescription else { return nil }
        
        return TripRepresentation(title: title, tripDescription: tripDescription, isPrivate: isPrivate, isProfessional: isProfessional/*boolToInt(isPrivate)*/, image: image/* boolToInt(isProfessional)*/, duration: duration, distance: distance, date: dateFormatter.string(from: date), tripType: tripType, id: Int(id)/*, userId: String(userId)*/)
    }
//    var profileForTrip: Profile? {
//        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
//        let context = CoreDataStack.shared.mainContext
//        do {
//            let profiles = try context.fetch(fetchRequest)
//            return profiles[profiles.startIndex]
//        } catch {
//            print("no profile")
//        }
//        return nil
//    }
    
    // MARK: - Initializers
    @discardableResult convenience init(date: Date,
                                        distance: Double,
                                        duration: Double,
                                        id: Int,
                                        image: String,
                                        isPrivate: Bool,
                                        isProfessional: Bool,
                                        title: String,
                                        tripDescription: String/*,
                                        userId: Int64*/,
        tripType: String,
        profile: Profile,
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
        self.tripType = tripType
        self.id = Int16(id)
        self.profile = profile
        
//        self.userId = userId
    }
    
    @discardableResult convenience init?(tripRepresentation: TripRepresentation, profile: Profile, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            return formatter
        }
        
        func intToBool(_ Int: Int) -> Bool {
            return (Int == 1 ? true : false)
        }
        
        guard let date = dateFormatter.date(from: tripRepresentation.date) else { return nil }
//        2019-06-01T00:00:00.000Z
        
        self.init(date: date,
                  distance: tripRepresentation.distance,
                  duration: tripRepresentation.duration,
                  id: tripRepresentation.id,
                  image: tripRepresentation.image,
                  isPrivate: tripRepresentation.isPrivate /*intToBool(tripRepresentation.isPrivate)*/,
            isProfessional: tripRepresentation.isProfessional /*intToBool(tripRepresentation.isProfessional)*/,
            title: tripRepresentation.title,
            tripDescription: tripRepresentation.tripDescription,
            tripType: tripRepresentation.tripType,
            profile: profile/*,
            userId: userId*/)
    }
    
    func boolToInt(_ boolean: Bool) -> Int {
        return (boolean ? 1 : 0)
    }
    
    
    
}
