//
//  AuthTokenViewModel.swift
//  MovieApp
//
//  Created by BS1010 on 10/11/22.
//

import Foundation

class AuthTokenViewModel: ObservableObject {
    func saveToken() {
        let token = "dummy-api-token"
        let service = "api-token"
        let account = "tmdb"
        
        do {
            try KeychainManager.save(service: service, account: account, data: token.data(using: .utf8) ?? Data())
        }
        catch {
            print(error)
        }
    }
    func deleteToken() {
        let service = "api-token"
        KeychainManager.delete(service: service)
    }
    
}
