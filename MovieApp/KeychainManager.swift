//
//  KeychainManager.swift
//  MovieApp
//
//  Created by BS1010 on 7/11/22.
//

import Foundation

class KeychainManager{
    
    enum KeychainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
    }
    
    static func save(
        service: String,
        account: String,
        data: Data
    ) throws {
        print("Saving \(service)")
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: data as AnyObject,
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        
        print("Saved")
    }
    
    static func get(
        service: String
    ) -> NSDictionary? {
        print("Reading data")
        print(service)
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: service as AnyObject,
            kSecReturnAttributes as String: kCFBooleanTrue,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        print(status)
        
        guard let dic = result as? NSDictionary else {
            print("Error converting dictionary")
            return NSDictionary()
        }
        
//        let username = dic[kSecAttrAccount] ?? ""
//
//        guard let passwordData = dic[kSecValueData] as? Data else {
//            print("Error converting password data")
//            return NSDictionary()
//        }
//
//        let password = String(data: passwordData, encoding: .utf8) ??
//
//        print(status)
//        print(username)
//        print(password)
//
        return dic
    }
    
    static func delete(service: String) {
        print("Deleting \(service)")
        
        let query = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: service as AnyObject,
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        
        print("Keychain deletion status: \(status)")
    }
}
