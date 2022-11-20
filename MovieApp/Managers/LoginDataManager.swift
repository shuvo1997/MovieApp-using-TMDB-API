//
//  LoginDataManager.swift
//  MovieApp
//
//  Created by BS1010 on 20/11/22.
//

import Foundation

enum UserState {
    case UserNameIncorrect
    case PasswordIncorrect
    case EmptyField
    case AllOk
}

class LoginDataManager: ObservableObject{
    @Published var keychainUsername = ""
    @Published var keychainPassword = ""
    @Published var username = ""
    @Published var password = ""
    @Published var isVerified = false
    
    init() {
        saveData()
    }
    
    func getLoginData() {
        let result = KeychainManager.get(service: "api.themoviedb.org")
        keychainUsername = result.username
        keychainPassword = result.password
    }
    
    func saveData() {
        do {
            try KeychainManager.save(service: "api.themoviedb.org", account: "Shuvo123", data: "123".data(using: .utf8) ?? Data())
        } catch {
            print(error)
        }
    }
    
    func deleteData() {
        KeychainManager.delete(service: "api.themoviedb.org")
    }
    
    func verify() -> UserState {
        if username != "" && password != "" {
            getLoginData()
            if username != keychainUsername {
                return UserState.UserNameIncorrect
            }
            if password != keychainPassword {
                return UserState.PasswordIncorrect
            }
            self.isVerified.toggle()
            return UserState.AllOk
        }
        else {
            return UserState.EmptyField
        }
    }
}
