//
//  EncodableExtension.swift
//  AddressFull
//
//  Created by MacBook Pro  on 20/11/23.
//

import Foundation


extension Encodable {
    func toJson() -> [String: Any]? {
        
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(self)
            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                print("************************************************************************************************")
                print("\nJson Request - \(jsonObject)\n")
                print("************************************************************************************************")
                return jsonObject
            }
            else {
                return nil
            }
        } catch {
            print("\nError encoding object to JSON or converting JSON data to dictionary: \(error)\n")
            return nil
        }
    }
    
    func toData() throws -> Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(self)
            return data
        } catch {
            throw error
        }
    }
}
