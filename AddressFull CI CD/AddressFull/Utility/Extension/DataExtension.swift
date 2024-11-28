//
//  DataExtension.swift
//  AddressFull
//
//  Created by MacBook Pro  on 30/10/23.
//

import Foundation


extension Data {
    
    func toString() -> String? {
        return self.base64EncodedString()
    }
}
