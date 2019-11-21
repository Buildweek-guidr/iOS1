//
//  APIController.swift
//  BuildWeekGuidr
//
//  Created by morse on 11/18/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation
import CoreData

class APIController {
    private let baseUrl = URL(string: "https://guidr-backend-api.herokuapp.com/api")!
    struct HTTPMethod {
        static let get = "GET"
        static let put = "PUT"
        static let post = "POST"
        static let delete = "DELETE"
    }
    
    enum NetworkError: Error {
        case noAuth, otherError, badData, noDecode
    }
    
   // MARK: - signIn
    
    func signIn(with username: String, and password: String, completion: @escaping (Error?) -> ()) {
        let loginUrl = baseUrl.appendingPathComponent("/accounts/login")
        
        var request = URLRequest(url: loginUrl)
        request.httpMethod = HTTPMethod.post
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let profile = Profile(username: username, password: password, age: nil, guideSpecialty: nil, title: nil, tagline: nil, yearsExperience: nil, token: nil)
        do {
            try CoreDataStack.shared.save(context: CoreDataStack.shared.container.newBackgroundContext())
        } catch {
            // don't print("Could not save profile.")
        }
//        guard let profile = profile else { return }
        
        guard let profileRepresentation = profile.profileRepresentation else {
            // don't print("Profile is nil")
            return
        }
        
//        // don't print(profile.profileRepresentation?  .username)
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(profile.profileRepresentation)
            request.httpBody = jsonData
        } catch {
            // don't print("Error encoding Profile object: \(error)")
            completion(error)
            return
        }
        // don't print(request)
        URLSession.shared.dataTask(with: request) { (data, _, error) in

            
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            let decoder = JSONDecoder()
            let context = CoreDataStack.shared.container.newBackgroundContext()
            do {
                let decoded = try decoder.decode(TokenRepresentation.self, from: data)
                let token = Token(tokenRepresentation: decoded, context: context)
                profile.token = token
                self.fetchProfile()
                do {
                    try CoreDataStack.shared.save(context: context)
                } catch {
                    // don't print("couldn't save token")
                }
//                profile.token = token
//                // don't print(self.profile?.token?.token)
//                self.fetchTrips()
                // don't print("hi")
            } catch {
                // don't print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    // MARK: - fetch
    
    func fetchTrips() {
        
        var profile: Profile?
                        
        //                fetch profile and set it
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        let context = CoreDataStack.shared.container.newBackgroundContext()
        do {
            let profiles = try context.fetch(fetchRequest)
            // don't print("Profiles: \(profiles.count)")
            profile = profiles.first
        } catch {
            // don't print("error fetching profile")
        }
//        // don't print("Token?: \(profile?.token)")
//        // don't print("Fetching!")
        guard let token = profile?.token else { return }
        
        let id = Int(token.userId)
        
        let tripsURL = baseUrl.appendingPathComponent("/users/\(id)/trips")
        
        var request = URLRequest(url: tripsURL)
        request.httpMethod = HTTPMethod.get
  
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.header
        guard let theToken = token.token else { return }
//        // don't print(theToken)
        request.addValue("\(theToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                // don't print("Error receiving Trips data: \(error)")
            }
            
            guard let data = data else {
                return
            }
//            // don't print("*****HERE*****")
//            // don't print(String(data: data, encoding: .utf8))
            
            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .secondsSince1970
            do {
                let decoded = try decoder.decode([TripRepresentation].self, from: data)
                self.updateTrips(with: decoded)

                return
            } catch {
                // don't print("Error decoding [Trip] object: \(error)")
                
                return
            }
        }.resume()
        return
    }
    
    // MARK: - CRUD for Profiles
    
    func fetchProfile() {
        var profile: Profile?
                                
                //                fetch profile and set it
                let tripsFetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        let context = CoreDataStack.shared.container.newBackgroundContext()
                do {
                    let profiles = try context.fetch(tripsFetchRequest)
                    // don't print("Profiles: \(profiles.count)")
                    profile = profiles.first
                } catch {
                    // don't print("error fetching profile")
                }
        //        // don't print("Token?: \(profile?.token)")
        //        // don't print("Fetching!")
                guard let token = profile?.token else { return }
                
                let id = Int(token.userId)
                
                let tripsURL = baseUrl.appendingPathComponent("/users/\(id)/profile")
                
                var request = URLRequest(url: tripsURL)
                request.httpMethod = HTTPMethod.get
          
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //        request.header
                guard let theToken = token.token else { return }
        //        // don't print(theToken)
                request.addValue("\(theToken)", forHTTPHeaderField: "Authorization")
                
                URLSession.shared.dataTask(with: request) { data, _, error in
                    
                    if let error = error {
                        // don't print("Error receiving Trips data: \(error)")
                    }
                    
                    guard let data = data else {
                        return
                    }
        //            // don't print("*****HERE*****")
        //            // don't print(String(data: data, encoding: .utf8))
                    
                    let decoder = JSONDecoder()
        //            decoder.dateDecodingStrategy = .secondsSince1970
                    do {
                        let decoded = try decoder.decode(ProfileRepresentation.self, from: data)
//                        self.updateTrips(with: decoded)
                        guard let age = decoded.age,
                            let yearsExperience = decoded.yearsExperience else { return }
                        profile?.age = age
                        profile?.guideSpecialty = decoded.guideSpecialty
                        profile?.tagline = decoded.tagline
                        profile?.title = decoded.title
                        profile?.yearsExperience = yearsExperience

                        return
                    } catch {
                        // don't print("Error decoding Profile object: \(error)")
                        
                        return
                    }
                }.resume()
                return
    }
    
    // MARK: - CRUD for Trips
    
    // MARK: - saveNewTrip
    
    func saveNewTrip(trip: Trip, completion: @escaping () -> Void = { }) {
        var profile: Profile?
        
        //                fetch profile and set it
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        let context = CoreDataStack.shared.container.newBackgroundContext()
        do {
            let profiles = try context.fetch(fetchRequest)
            // don't print("Profiles: \(profiles.count)")
            profile = profiles.first
        } catch {
            // don't print("error fetching profile")
        }
        //        // don't print("Token?: \(profile?.token)")
        //        // don't print("Fetching!")
        guard let token = profile?.token else { return }
        
//        let id = Int(token.userId)
        
        let tripsURL = baseUrl.appendingPathComponent("/trips")
        
        // don't print(tripsURL)
        var request = URLRequest(url: tripsURL)
        request.httpMethod = HTTPMethod.post
        // don't print("Request: \(request)")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let theToken = token.token else { return }
        //        // don't print(theToken)
        request.addValue("\(theToken)", forHTTPHeaderField: "Authorization")
        
//        set json body
        guard let tripRepresentation = trip.tripRepresentation else {
            // don't print("Trip representation is nil")
            completion()
            return
        }
        
        do {
            try CoreDataStack.shared.save(context: context)
            request.httpBody = try JSONEncoder().encode(tripRepresentation)
            // don't print(request.httpBody)
        } catch {
            // don't print("Error encoding or saving trip representation to disk: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            completion()
            
            if let error = error {
                // don't print("Error POSTing trip to server: \(error)")
                completion()
                return
            }
            
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(TripRepresentation.self, from: data)
                    guard let id = decoded.id else {
                        // don't print("Could not get id back from server: \(trip)")
                        return
                    }
                    trip.id = Int16(id)
                    do {
                        try CoreDataStack.shared.save(context: context)
                    } catch {
                        // don't print("could not save id: \(error)")
                    }
                } catch {
                    // don't print("Unable to decode data in object of type TripRepresentation: \(error)")
                }
            }
            completion()
        }.resume()
    }
    
    // MARK: - deleteTrip
    
    
    func deleteTrip(_ trip: Trip, completion: @escaping () -> Void = { }) {
        
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        context.perform {
            do {
                context.delete(trip)
                try CoreDataStack.shared.save(context: context)
            } catch {
                context.reset()
                // don't print("Error deleting object from managed object context: \(error)")
            }
            
            let requestURL = self.baseUrl.appendingPathComponent("trips").appendingPathComponent("\(trip.id)") .appendingPathExtension("json")
            var request = URLRequest(url: requestURL)
            request.httpMethod = HTTPMethod.delete
            
            URLSession.shared.dataTask(with: request) { _, response, _ in
                // don't print(response!)
                completion()
            }.resume()
        }
    }
    
    // MARK: - Internal Methods
    
    func updateTrips(with representations: [TripRepresentation]) {
        
        // Which representations do we already have in Core Data?
        
        let tripsToFetch = representations.map { $0.id }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(tripsToFetch, representations))
        
        // Make a mutable copy of the dictionary above
        
        var tripsToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        // Only fetch trips with these identifiers id IN %@
//        fetchRequest.predicate = NSPredicate(format: "id IN %@", tripsToFetch)
        
        //        let context = CoreDataStack.shared.container.newBackgroundContext()
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.perform {
            
            do {
                let existingTrips = try context.fetch(fetchRequest)
                var dateFormatter: DateFormatter {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    return formatter
                }
                var trips: [Trip] = []
                
                // Update the ones we do have
                
                for trip in existingTrips {
                    // don't print("\(trip.id)**********here*******************************")
                    // Grab the TripRepresentation that corresponds to this trip
                    let identifier = Int(trip.id)
                    guard let representation = representationsByID[identifier],
                        let tripId = representation.id else { continue }
                    // don't print("SAME? \(trip.id)=\(representation.id)")
                    // This can be abstracted out to another function
                    trip.date = dateFormatter.date(from: representation.date)
                    trip.distance = representation.distance
                    trip.duration = representation.duration
                    trip.image = representation.image
                    trip.isPrivate = representation.isPrivate
                    trip.isProfessional = representation.isProfessional
                    trip.title = representation.title
                    trip.tripDescription = representation.tripDescription
                    trip.id = Int16(tripId)
                    trips.append(trip)
                    
                    tripsToCreate.removeValue(forKey: identifier)
                }
                
                
                
                // fetch profile and set it
                var profile: Profile?
                let tripsFetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
                
                // Figure out which ones we don't have
                do {
                    let profiles = try context.fetch(tripsFetchRequest)
                    // don't print("Profiles: \(profiles.count)")
                    profile = profiles.first
                } catch {
                    // don't print("error fetching profile")
                }
                
                for representation in tripsToCreate.values {
                    // pass profile in
                    guard let profile = profile else { continue }
                    Trip(tripRepresentation: representation, profile: profile, context: context)
                    // don't print("Trip created: \(representation.id)")
                }
                try CoreDataStack.shared.save(context: context)
                profile?.trips = NSOrderedSet(array: trips)
                try CoreDataStack.shared.save(context: context)
            } catch {
                // don't print("Error adding trips to persistent store: \(error)")
            }
        }
    }
}
