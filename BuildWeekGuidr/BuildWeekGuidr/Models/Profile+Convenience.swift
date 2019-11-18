//
//  Profile+Convenience.swift
//  BuildWeekGuidr
//
//  Created by morse on 11/18/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation
import CoreData

extension Profile {
    
    // MARK: - Properties
    
    var profileRepresentation: ProfileRepresentation? {
        
        guard let guideSpecialty = guideSpecialty,
            let password = password,
            let tagline = tagline,
            let title = title,
            let username = username,
            let token = token,
            let tokenRepresentation = token.tokenRepresentation else { return nil }
        
        return ProfileRepresentation(age: age,
                                     guideSpecialty: guideSpecialty, password: password, tagline: tagline, title: title, username: username, yearsExperience: yearsExperience,
                                     token: tokenRepresentation)
    }
    
    // MARK: - Initializers
    
    @discardableResult convenience init(username: String,
                                        password: String,
                                        age: Int16,
                                        guideSpecialty: String,
                                        title: String,
                                        tagline: String,
                                        yearsExperience: Int,
                                        token: Token,
                                        trips: [Trip] = [],
                                        insertInto context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.username = username
        self.password = password
        self.token = token
        self.age = age
        self.guideSpecialty = guideSpecialty
        self.trips = NSOrderedSet(array: trips)
    }
    
    @discardableResult convenience init(profileRepresentation: ProfileRepresentation) {
        
        let token = Token(tokenRepresentation: profileRepresentation.token, context: CoreDataStack.shared.mainContext)
        
        self.init(username: profileRepresentation.username,
                  password: profileRepresentation.password,
                  age: profileRepresentation.age,
                  guideSpecialty: profileRepresentation.guideSpecialty,
                  title: profileRepresentation.title,
                  tagline: profileRepresentation.tagline,
                  yearsExperience: Int(profileRepresentation.yearsExperience),
                  token: token)
    }
}
