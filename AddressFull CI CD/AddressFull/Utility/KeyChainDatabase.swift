//
//  KeyChainDatabase.swift
//  AddressFull
//
//  Created by MacBook Pro  on 30/10/23.
//

import Foundation
import Security


class KeyChain {
    func save(data: Data, key: String, group: String?) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        //    if let group = group {
        //        query[kSecAttrAccessGroup as String] = group
        //    }
        
        SecItemDelete(query as CFDictionary) // Delete existing item if it exists
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func load(key: String, group: String?) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        //    if let group = group {
        //        query[kSecAttrAccessGroup as String] = group
        //    }
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return data
        } else {
            return nil
        }
    }
    
    func update(data: Data, key: String, group: String?) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        //    if let group = group {
        //        query[kSecAttrAccessGroup as String] = group
        //    }
        
        let attributesToUpdate: [String: Any] = [
            kSecValueData as String: data
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        return status == errSecSuccess
    }
    
    func delete(key: String, group: String?) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        //    if let group = group {
        //        query[kSecAttrAccessGroup as String] = group
        //    }
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
