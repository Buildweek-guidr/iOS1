////
////  APIController.swift
////  BuildWeekGuidr
////
////  Created by morse on 11/18/19.
////  Copyright © 2019 morse. All rights reserved.
////
//
//import Foundation
//
//class APIController {
//    private let baseUrl = URL(string: "https://guidr-backend-api.herokuapp.com/api")!
//    var token: Token?
//    
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
//    
//    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
//        let loginUrl = baseUrl.appendingPathComponent("users/login")
//        
//        var request = URLRequest(url: loginUrl)
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
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
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
//            guard let data = data else {
//                completion(NSError())
//                return
//            }
//            
//            let decoder = JSONDecoder()
//            do {
//                self.bearer = try decoder.decode(Bearer.self, from: data)
//            } catch {
//                print("Error decoding bearer object: \(error)")
//                completion(error)
//                return
//            }
//            
//            completion(nil)
//        }.resume()
//    }
//}
