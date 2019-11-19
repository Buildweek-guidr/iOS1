//
//  TripRepresentation.swift
//  BuildWeekGuidr
//
//  Created by morse on 11/18/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation

struct TripRepresentation: Codable {
    let title: String
    let tripDescription: String
    let isPrivate: Int
    let isProfessional: Int
    let image: String
    let duration: Double // In days
    let distance: Double // In miles
    let date: String // YYYY-MM-DD
    let tripType: String
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case title, isPrivate, isProfessional, image, duration, distance, date, tripType
        case userId = "user_id"
        case tripDescription = "description"
    }
}
