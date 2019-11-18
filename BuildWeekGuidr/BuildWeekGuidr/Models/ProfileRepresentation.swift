//
//  ProfileRepresentation.swift
//  BuildWeekGuidr
//
//  Created by morse on 11/18/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation

struct ProfileRepresentation: Codable {
    let age: Int16
    let guideSpecialty: String
    let password: String
    let tagline: String
    let title: String
    let username: String
    let yearsExperience: Int16
    let token: TokenRepresentation
}
