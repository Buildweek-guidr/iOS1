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
    
    var token: Token?
    
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
//        request.addValue(username, forHTTPHeaderField: "username")
//        request.addValue(password, forHTTPHeaderField: "password")
        
        
        let profile = Profile(username: username, password: password, age: nil, guideSpecialty: nil, title: nil, tagline: nil, yearsExperience: nil, token: nil)
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(profile.profileRepresentation)
            request.httpBody = jsonData
            print(String(data: jsonData, encoding: .utf8))
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        print(request)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
//            if let response = response as? HTTPURLResponse,
//                response.statusCode != 200 {
//                completion(NSError(domain: "", code: response.statusCode, userInfo:nil))
//                return
//            }
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            let decoder = JSONDecoder()
            print(String(data: data, encoding: .utf8))
            do {
                let profileRep = try decoder.decode(ProfileRepresentation.self, from: data)
                print(profileRep.username)
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
}
