//
//  APIService.swift
//  MovieApp
//
//  Created by BS1010 on 8/11/22.
//

import Foundation

class APIService {
    static let shared = APIService()
    enum APIError: Error {
        case error
    }

//    func login(credentials: Credentials,
//               completion: @escaping (Result<Bool,APIError>) -> Void) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            if credentials.password == "password" {
//                completion(.success(true))
//            } else {
//                completion(.failure(APIError.error))
//            }
//        }
//    }
}

