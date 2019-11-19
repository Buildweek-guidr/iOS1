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
                
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func fetchTrips(completion: @escaping (Result<[TripRepresentation], NetworkError>) -> Void) {
        guard let profile = profile,
            let token = profile.token else {
            completion(.failure(.noAuth))
            return
        }
        
        let tripsURL = baseUrl.appendingPathComponent("/users/\(token.userId)/trips")
        
        var request = URLRequest(url: tripsURL)
        request.httpMethod = HTTPMethod.get
//        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
//            if let response = response as? HTTPURLResponse,
//            response.statusCode == 401 {
//                completion(.failure(.badAuth))
//                return
//            }
            
            if let error = error {
                print("Error receiving animal name data: \(error)")
                completion(.failure(.otherError))
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .secondsSince1970
            do {
                let decoded = try decoder.decode([TripRepresentation].self, from: data)
                for trip in decoded {
                    print(trip.date)
                }
                completion(.success(decoded))
            } catch {
                print("Error decoding animal object: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    
}
