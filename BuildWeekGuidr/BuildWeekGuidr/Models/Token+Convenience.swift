//
//  Token+Convenience.swift
//  BuildWeekGuidr
//
//  Created by morse on 11/18/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation
import CoreData

extension Token {
    
    // MARK: - Properties
    
    var tokenRepresentation: TokenRepresentation? {
        
        guard let token = token/*,
            let userId = userId*/,
            let username = username else { return nil }
        
        return TokenRepresentation(token: token, userId: userId, username: username)
    }
    
    // MARK: - Initializers
    
    @discardableResult convenience init(token: String, userId: Int64, username: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.token = token
        self.userId = userId
        self.username = username
    }
    
    @discardableResult convenience init(tokenRepresentation: TokenRepresentation, context: NSManagedObjectContext) {
        self.init(token: tokenRepresentation.token,
                  userId: tokenRepresentation.userId,
                  username: tokenRepresentation.username)
    }
}
