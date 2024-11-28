//
//  KeyExchangeReponseModel.swift
//  AddressFull
//
//  Created by Sneh on 12/1/23.
//

import Foundation


import Foundation

struct KeyExchageResponseModel: Codable {
    let status: Int?
    let data: KeyExchageData?
}


struct KeyExchageData: Codable {
    let encrypted_key, encrypted_iv, encrypted_publicKey: String?

    enum CodingKeys: String, CodingKey {
        case encrypted_key = "encrypted_key"
        case encrypted_iv = "encrypted_iv"
        case encrypted_publicKey = "encrypted_public_key"
    }
}
