//
//  TokenRepresentation.swift
//  BuildWeekGuidr
//
//  Created by morse on 11/18/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation

struct TokenRepresentation: Codable {
    let token: String
    let userId: Int64
    let username: String
}
