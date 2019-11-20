//
//  APIController.swift
//  BuildWeekGuidr
//
//  Created by morse on 11/18/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation

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
    
    
    var profile: Profile?
    
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
        
        profile = Profile(username: username, password: password, age: nil, guideSpecialty: nil, title: nil, tagline: nil, yearsExperience: nil, token: nil)
        do {
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
        } catch {
            print("Could not save profile.")
        }
//        guard let profile = profile else { return }
        
        guard let profileRepresentation = profile?.profileRepresentation else {
            print("Profile is nil")
            return
        }
        
//        print(profile.profileRepresentation?  .username)
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(profile?.profileRepresentation)
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
                self.profile?.token = token
                print(self.profile?.token?.token)
                self.fetchTrips()
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
//    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
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
        guard let profile = profile,
            let token = profile.token else { return }
        
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
        print(theToken)
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
            print("*****HERE*****")
            print(String(data: data, encoding: .utf8))
            
            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .secondsSince1970
            do {
                let decoded = try decoder.decode([TripRepresentation].self, from: data)
                
                var trips: [Trip] = []
                for tripRepresentation in decoded {
                    print(tripRepresentation.title)
                    if let trip = Trip(tripRepresentation: tripRepresentation) {
                        trips.append(trip)
                        print(trip.title)
                    } else {
                        print("FAIL! BUT YOU GOT THIS!!!")
                    }
                }
                profile.trips = NSOrderedSet(array: trips)
//                if let trips = profile.trips {
//                    for trip in trips {
//                        print((trip).title)
//                    }
//                }
                do {
                    try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
                } catch {
                    print("Could not save trips.")
                }
                return
            } catch {
                print("Error decoding [Trip] object: \(error)")
                
                return
            }
        }.resume()
        return
    }
    
    
}
