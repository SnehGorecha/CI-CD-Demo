//
//  KeyExchange.swift
//  AddressFull
//
//  Created by Sneh on 12/14/23.
//

import Foundation
import UIKit


class KeyExchange {
    
    public static var completion : ((Bool,String) -> Void)?
    
    /// Use this function to retrive public key, private key and server public key from keychain database
    public static func retriveKeysFromKeyChain(view_for_progress_indicator: UIView) {
        if let loaded_private_key = KeyChain().load(key: KeyChainKey.private_key, group: KeyChainKey.group),
           let loaded_public_key = KeyChain().load(key: KeyChainKey.public_key, group: KeyChainKey.group),
           let server_public_key = KeyChain().load(key: KeyChainKey.server_public_key, group: KeyChainKey.group) {
            
            let privateKey = self.convertDataToRSAKey(key: loaded_private_key)
            let publicKey  = self.appendDataToRSAKey(key: self.convertDataToRSAKey(key: loaded_public_key))
            let serverPublicKey  = self.appendDataToRSAKey(key: self.convertDataToRSAKey(key: server_public_key))
            
            print("\nSaved Private key - \(privateKey)\n")
            print("\nSaved Public key - \(publicKey)\n")
            print("\nSaved Server Public key - \(serverPublicKey)\n")
            
            if let completion = self.completion {
                completion(true,"")
            }
        }
        else {
            self.generatePublicAndPrivateRSAKeyPair(view_for_progress_indicator: view_for_progress_indicator)
        }
    }
    
    
    /// Use this function to generate new public key and private key and save it to keychain
    public static func generatePublicAndPrivateRSAKeyPair(view_for_progress_indicator: UIView, call_key_exchange_api: Bool = false) {
        let data = KeyEncryption().generateRSAKeyPair()
        
        if let data = data {
            let private_key = data.privateKey
            let public_key = data.publicKey
            
            
            print("\nNew generated Private key - \(self.convertDataToRSAKey(key: private_key))\n")
            print("\nNew generated Public key - \(self.appendDataToRSAKey(key: self.convertDataToRSAKey(key: public_key)))\n")
            
            let is_private_key_saved = KeyChain().save(data: private_key, key: KeyChainKey.private_key, group: KeyChainKey.group)
            let is_public_key_saved = KeyChain().save(data: public_key, key: KeyChainKey.public_key, group: KeyChainKey.group)
            
            print("\nNew generated Private key \(is_private_key_saved ? "saved" : "not saved")\n")
            print("\nNew generated Public key \(is_public_key_saved ? "saved" : "not saved")\n")
            
            if call_key_exchange_api {
                
                self.callKeyExchangeApi(public_key: public_key.toString() ?? "", view_for_progress_indicator: view_for_progress_indicator)
                
            } else {
                if let completion = self.completion {
                    completion(true,"")
                }
            }
        } else {
            
            if let completion = self.completion {
                completion(false,Message.something_went_wrong())
            }

            self.deleteKeysFromKeychain()
        }
    }
    
    
    /// Use this function to call key exchange api
    public static func callKeyExchangeApi(public_key: String,view_for_progress_indicator: UIView) {
        
        AlamofireAPICallManager.shared.header = [ApiHeaderAndParameters.s_api_key: GlobalVariables.shared.device_id,
                                                 ApiHeaderAndParameters.x_api_key : public_key]
        
        AlamofireAPICallManager.shared.apiCall(
            KeyExchageResponseModel.self,
            to: .key_exchange,
            with: nil,
            view_for_progress_indicator: view_for_progress_indicator) { isSuccess, responseModel, errorMessage, encryptedResponse in
                if isSuccess {
                    
                    // ENCRYPTED RESPONSE
                    if let response = encryptedResponse {
                        EncryptionDecryption.decryptResponse(KeyExchageResponseModel.self, response: response, completion: { isSuccess, responseModel, error_message in
                            if isSuccess ,
                               let public_key = responseModel?.data?.encrypted_publicKey {
                                
                                let new_public_key = Encryption.removeBeginAndEndFromPublicKey(key: public_key)
                                
                                if let data = Data(base64Encoded: new_public_key) {
                                    let is_server_public_key_saved = KeyChain().save(data: data, key: KeyChainKey.server_public_key, group: KeyChainKey.group)
                                    print("\nDecrypted server public key \(is_server_public_key_saved ? "saved" : "not saved") \n")
                                    
                                    if let completion = self.completion {
                                        completion(true,"")
                                    }
                                }
                                
                            } else {
                                if let completion = self.completion {
                                    completion(false,error_message ?? "")
                                }
                            }
                        })
                    }
                    
                    // NORMAL RESPONSE
                    else if let model = responseModel {
                        if let data = Data(base64Encoded: model.data?.encrypted_publicKey ?? "") {
                            let _ = KeyChain().save(data: data, key: KeyChainKey.server_public_key, group: KeyChainKey.group)
                        }
                    }
                } else {
                    if let completion = self.completion {
                        completion(false,errorMessage ?? Message.something_went_wrong())
                    }
                }
            }
    }
    
    
    /// Use this function to delete public key, private key and server public key from keychain
    public static func deleteKeysFromKeychain() {
        let is_private_key_deleted =  KeyChain().delete(key: KeyChainKey.private_key, group: KeyChainKey.group)
        let is_public_key_deleted = KeyChain().delete(key: KeyChainKey.public_key, group: KeyChainKey.group)
        let is_server_public_key_deleted = KeyChain().delete(key: KeyChainKey.server_public_key, group: KeyChainKey.group)
        
        print("\nIs private_key delete from keychain - \(is_private_key_deleted)")
        print("Is public_key delete from keychain - \(is_public_key_deleted)")
        print("Is server_public_key delete from keychain - \(is_server_public_key_deleted)\n")
    }
    
    fileprivate static func convertDataToRSAKey(key: Data) -> String {
        return key.base64EncodedString(options: .endLineWithLineFeed).replacingOccurrences(of: "\n", with: "|").replacingOccurrences(of: "\n", with: "")
    }
    
    fileprivate static func appendDataToRSAKey(key: String) -> String {
        return "-----BEGIN PUBLIC KEY-----|\(key)|-----END PUBLIC KEY-----"
    }
    
    fileprivate static func convertToPEMFormat(publicKeyData: Data) -> String? {
        let base64EncodedKey = publicKeyData.base64EncodedString(options: [])
        
        // Wrap the base64 encoded key in PEM format
        let pemFormattedKey = """
        -----BEGIN PUBLIC KEY-----
        \(base64EncodedKey)
        -----END PUBLIC KEY-----
        """
        
        return pemFormattedKey
    }
    
}
