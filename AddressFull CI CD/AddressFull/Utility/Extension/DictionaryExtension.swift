//
//  DictionaryExtension.swift
//  AddressFull
//
//  Created by MacBook Pro  on 20/11/23.
//

import Foundation


extension Dictionary {
    func toJson() -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)

            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                return jsonString
            }
            else {
                return nil
            }
        } catch {
            print("Error converting dictionary to JSON: \(error)")
            return nil
        }
    }
    
    func toData() -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self)
            return jsonData
        } catch {
            print("Error converting dictionary to JSON: \(error)")
            return nil
        }
    }
    
    func formatDictionary() -> String {
        return self.map { "\($0.key) : \($0.value)" }.joined(separator: ", ")
    }
}
