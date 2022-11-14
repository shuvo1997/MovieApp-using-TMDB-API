//
//  AuthTokenViewModel.swift
//  MovieApp
//
//  Created by BS1010 on 10/11/22.
//

import Foundation

class AuthTokenViewModel: ObservableObject {
//    var time = 0
//    let timeOut = 30
    
    
//    func checkExpired(currentTime: Int) -> Bool{
//        print("Current time\(currentTime)")
//        if currentTime - time >= 30 {
//            return true
//        }
//        else {
//            return false
//        }
//    }
    
    func saveToken() {
        let token = "dummy-api-token"
        let service = "api-token"
        let account = "tmdb"
        
        do {
            try KeychainManager.save(service: service, account: account, data: token.data(using: .utf8) ?? Data())
//            time = getTime()
//            print("Started time \(time)")
        }
        catch {
            print(error)
        }
    }
//
//    func getTime()->Int{
//        let time = Date()
//        let timeFormatter = DateFormatter()
//        timeFormatter.dateFormat = "ss"
//        let stringDate = timeFormatter.string(from: time)
//        return Int(stringDate) ?? 0
//    }
    
    func deleteToken() {
        let service = "api-token"
        KeychainManager.delete(service: service)
//        time = 0
    }
    
}
