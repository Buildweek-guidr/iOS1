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
    
    
//    var profile: Profile?
    
//    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
//        let signUpUrl = baseUrl.appendingPathComponent("users/signup")
//
//        var request = URLRequest(url: signUpUrl)
//        request.httpMethod = HTTPMethod.post.rawValue
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let jsonEncoder = JSONEncoder()
//        do {
//            let jsonData = try jsonEncoder.encode(user)
//            request.httpBody = jsonData
//        } catch {
//            print("Error encoding user object: \(error)")
//            completion(error)
//            return
//        }
//        URLSession.shared.dataTask(with: request) { (_, response, error) in
//            if let response = response as? HTTPURLResponse,
//                response.statusCode != 200 {
//                completion(NSError(domain: "", code: response.statusCode, userInfo:nil))
//                return
//            }
//
//            if let error = error {
//                completion(error)
//                return
//            }
//
//            completion(nil)
//            }.resume()
//    }
    
    
//    Login
//
//    Route:
//    /accounts/login
//
//    Method:
//    POST
//
//    Description:
//    Send user credentials to login to the application
//
//    Body:
//
//    { "username": STRING, "password": STRING }
//    Returns:
//    User Login Object
//
//    { "userId": INTEGER, "username": STRING, "token": STRING }
    
    
    func signIn(with username: String, and password: String, completion: @escaping (Error?) -> ()) {
        let loginUrl = baseUrl.appendingPathComponent("/accounts/login")
        
        var request = URLRequest(url: loginUrl)
        request.httpMethod = HTTPMethod.post
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let profile = Profile(username: username, password: password, age: nil, guideSpecialty: nil, title: nil, tagline: nil, yearsExperience: nil, token: nil)
        do {
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
        } catch {
            print("Could not save profile.")
        }
//        guard let profile = profile else { return }
        
        guard let profileRepresentation = profile.profileRepresentation else {
            print("Profile is nil")
            return
        }
        
//        print(profile.profileRepresentation?  .username)
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(profile.profileRepresentation)
            request.httpBody = jsonData
        } catch {
            print("Error encoding Profile object: \(error)")
            completion(error)
            return
        }
        print(request)
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
            do {
                let decoded = try decoder.decode(TokenRepresentation.self, from: data)
                let token = Token(tokenRepresentation: decoded, context: CoreDataStack.shared.mainContext)
                profile.token = token
                do {
                    try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
                } catch {
                    print("couldn't save token")
                }
//                profile.token = token
//                print(self.profile?.token?.token)
                self.fetchTrips()
                print("hi")
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
//    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
//        let signInURL = baseUrl.appendingPathComponent("users/login")
//        var request = URLRequest(url: signInURL)
//        request.httpMethod = HTTPMethod.post.rawValue
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let jsonEncoder = JSONEncoder()
//        do {
//            let jsonData = try jsonEncoder.encode(user)
//            request.httpBody = jsonData
//        } catch {
//            print("Error encoding user object: \(error)")
//            completion(error)
//            return
//        }
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let response = response as? HTTPURLResponse,
//                response.statusCode != 200 {
//                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
//                return
//            }
//            if let error = error {
//                completion(error)
//                return
//            }
//            guard let data = data else {
//                completion(NSError())
//                return
//            }
//            let decoder = JSONDecoder()
//            do{
//                self.bearer = try decoder.decode(Bearer.self, from: data)
//            } catch {
//                print("Error decoing bearer object: \(error)")
//                completion(error)
//                return
//            }
//            completion(nil)
//        }.resume()
//    }
    
    func fetchTrips() {
        
        var profile: Profile?
                        
        //                fetch profile and set it
        let tripsFetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        let context = CoreDataStack.shared.mainContext
        do {
            let profiles = try context.fetch(tripsFetchRequest)
            print("Profiles: \(profiles.count)")
            profile = profiles.first
        } catch {
            print("error fetching profile")
        }
//        print("Token?: \(profile?.token)")
//        print("Fetching!")
        guard let token = profile?.token else { return }
        
        let id = Int(token.userId)
        
        let tripsURL = baseUrl.appendingPathComponent("/users/\(id)/trips")
        print(tripsURL)
        
        var request = URLRequest(url: tripsURL)
        request.httpMethod = HTTPMethod.get
        
//        do {
//            let tokenRepresentation = token.tokenRepresentation
//            let encodedToken = try JSONEncoder().encode(tokenRepresentation)
//        } catch {
//            print("Can't encode token.")
//        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.header
        guard let theToken = token.token else { return }
//        print(theToken)
        request.addValue("\(theToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
//            if let response = response as? HTTPURLResponse,
//            response.statusCode == 401 {
//                completion(.failure(.badAuth))
//                return
//            }
            
            if let error = error {
                print("Error receiving Trips data: \(error)")
            }
            
            guard let data = data else {
                return
            }
//            print("*****HERE*****")
//            print(String(data: data, encoding: .utf8))
            
            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .secondsSince1970
            do {
                let decoded = try decoder.decode([TripRepresentation].self, from: data)
                self.updateTrips(with: decoded)
//                var trips: [Trip] = []
//                for tripRepresentation in decoded {
//                    print(tripRepresentation.title)
//                    if let trip = Trip(tripRepresentation: tripRepresentation) {
//                        trips.append(trip)
//                        print(trip.title)
//                    } else {
//                        print("FAIL! BUT YOU GOT THIS!!!")
//                    }
//                }
//                profile.trips = NSOrderedSet(array: trips)
//                if let trips = profile.trips {
//                    for trip in trips {
//                        print((trip).title)
//                    }
//                }
//                do {
//                    try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
//                } catch {
//                    print("Could not save trips.")
//                }
                return
            } catch {
                print("Error decoding [Trip] object: \(error)")
                
                return
            }
        }.resume()
        return
    }
    
    func updateTrips(with representations: [TripRepresentation]) {
        
        // Which representations do we already have in Core Data?
        
        let tripsToFetch = representations.map { $0.id }
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(tripsToFetch, representations))
        
        // Make a mutable copy of the dictionary above
        
        var tripsToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        // Only fetch tasks with these identifiers
        fetchRequest.predicate = NSPredicate(format: "id IN %@", tripsToFetch)
        
//        let context = CoreDataStack.shared.container.newBackgroundContext()
        let context = CoreDataStack.shared.mainContext
        
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
                    
                    // Grab the TripRepresentation that corresponds to this task
                    let identifier = Int(trip.id)
                    guard let representation = representationsByID[identifier] else { continue }
                    // This can be abstracted out to another function
                    trip.date = dateFormatter.date(from: representation.date)
                    trip.distance = representation.distance
                    trip.duration = representation.duration
                    trip.image = representation.image
                    trip.isPrivate = representation.isPrivate
                    trip.isProfessional = representation.isProfessional
                    trip.title = representation.title
                    trip.tripDescription = representation.tripDescription
                    trip.id = Int16(representation.id)
                    trips.append(trip)
                    
                    tripsToCreate.removeValue(forKey: identifier)
                }
                
                // Figure out which ones we don't have
                
                var profile: Profile?
                
                // fetch profile and set it
                let tripsFetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
                let context = CoreDataStack.shared.mainContext
                do {
                    let profiles = try context.fetch(tripsFetchRequest)
                    print("Profiles: \(profiles.count)")
                    profile = profiles.first
                } catch {
                    print("error fetching profile")
                }
                
                for representation in tripsToCreate.values {
                    // pass profile in
                    guard let profile = profile else { continue }
                    Trip(tripRepresentation: representation, profile: profile, context: context)
                    print("Trip created: \(representation.id)")
                }
                try CoreDataStack.shared.save(context: context)
                profile?.trips = NSOrderedSet(array: trips)
                try CoreDataStack.shared.save(context: context)
            } catch {
                print("Error adding tasks to persistent store: \(error)")
            }
        }
    }
}
