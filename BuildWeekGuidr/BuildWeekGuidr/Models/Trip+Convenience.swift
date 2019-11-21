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
        
        return TripRepresentation(title: title,
                                  tripDescription: tripDescription,
                                  isPrivate: isPrivate,
                                  isProfessional: isProfessional,
                                  image: image,
                                  duration: duration,
                                  distance: distance,
                                  date: dateFormatter.string(from: date),
                                  tripType: tripType,
                                  id: Int(id)/*,
                                  userId: Int(userId)*/)
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
                                        id: Int16? = nil,
                                        image: String,
                                        isPrivate: Bool,
                                        isProfessional: Bool,
                                        title: String,
                                        tripDescription: String,/*
                                        userId: Int64,*/
        tripType: String,
        profile: Profile,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        if let id = id {
            self.id = id
        }
        
        self.date = date
        self.distance = distance
        self.duration = duration
        self.image = image
        self.isPrivate = isPrivate
        self.isProfessional = isProfessional
        self.title = title
        self.tripDescription = tripDescription
        self.tripType = tripType
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
        var int16Id: Int16?
        if let tripId = tripRepresentation.id {
            int16Id = Int16(tripId)
        } else {
            int16Id = nil
        }
        
        guard let date = dateFormatter.date(from: tripRepresentation.date) else { return nil }
//        2019-06-01T00:00:00.000Z
//        , let tripIdInt = tripRepresentation.id, let tripId = Int16(tripIdInt)
//        guard let profile = profile else { return }
        self.init(date: date,
                  distance: tripRepresentation.distance,
                  duration: tripRepresentation.duration,
                  id: int16Id,
                  image: tripRepresentation.image,
                  isPrivate: tripRepresentation.isPrivate,
            isProfessional: tripRepresentation.isProfessional,
            title: tripRepresentation.title,
            tripDescription: tripRepresentation.tripDescription/*,
            userId: Int64(tripRepresentation.userId)*/,
            tripType: tripRepresentation.tripType,
            profile: profile)
    }
    
    
    
    
    
}
