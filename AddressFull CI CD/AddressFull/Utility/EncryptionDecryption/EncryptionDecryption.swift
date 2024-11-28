//
//  EncryptionDecryption.swift
//  AddressFull
//
//  Created by Sneh on 12/4/23.
//

import Foundation


class EncryptionDecryption {
    
    /// Use this function to encrypt normal request using server public key
    public static func encryptRequest <T: Encodable> (_ decoder: T) -> String? {
        do {
            
            // JUST FOR REFERENCE
            _ = decoder.toJson()
            
            // CONVERT MODEL CLASS INTO JSON DATA
            if let model_data = try decoder.toData() {
                
                // ENCRYPT JSON DATA FROM NEW IV AND KEY
                let encrypted_data = Encryption.encryptDataFromIvAndKey(from: model_data)
                
                if let iv = encrypted_data.iv,
                   let key = encrypted_data.key,
                   let encrypted_model = encrypted_data.encrypted_data {
                    
                    // CONVERT IV AND KEY FROM SERVER PUBIC KEY
                    let encrypted_iv_key = Encryption.encryptIvAndKeyFromPublicKey(iv: iv, key: key)
                    
                    if let encrypted_iv = encrypted_iv_key.encrypted_iv,
                       let encrypted_key = encrypted_iv_key.encrypted_key {
                        
                        // MAKE SINGLE STRING WITH PIPE SEPERATED
                        let final_string = Encryption.createFinalStringForApiRequest(from: encrypted_model, encrypted_iv: encrypted_iv, encrypted_key: encrypted_key)
                        
                        return final_string
                        
                    } else {
                        print("Error in encrypt iv and key using server public key")
                        return nil
                    }
                } else {
                    print("Error in encrypt Model data using new iv and key")
                    return nil
                }
            } else {
                print("Error in decode request Model data")
                return nil
            }
        } catch (let err) {
            print("Try catch error in decode data : \(err.localizedDescription)")
            return nil
        }
    }
    
    
    /// Use this function to decrypt response using private key
    public static func decryptResponse <T: Decodable> (_ decoder: T.Type,response: String,completion: @escaping (_ isSuccess: Bool, T?, _ errorMessage: String?) -> Void) {
        
        // SEPERATE RESPONSE WITH PIPE
        let seperated_response = response.seperateByPipe()
        
        EncryptionDecryption().decryptStringToModel(decoder, data: seperated_response.0, key: seperated_response.1, iv: seperated_response.2,completion: completion)
    }
    
    
    /// Use this function to decrypt response using private key
    fileprivate func decryptStringToModel <T: Decodable> (_ decoder: T.Type,data: String,key: String,iv: String,completion: @escaping (_ isSuccess: Bool, T?, _ errorMessage: String?) -> Void) {
        if let saved_private_key = KeyChain().load(key: KeyChainKey.private_key, group: KeyChainKey.group),
           let saved_public_key = KeyChain().load(key: KeyChainKey.public_key, group: KeyChainKey.group) {
            
            // LOAD PRIVATE AND PUBLIC KEYS
            if let private_sec_key = SecKey.loadFromData(saved_private_key,isForPrivateKey: true),
               let public_sec_key = SecKey.loadFromData(saved_public_key) {
                
                if let encrypted_iv_data = Data(base64Encoded: iv),
                   let encrypted_key_data = Data(base64Encoded: key) {
                    
                    // DECRYPT IV AND KEY USING USER'S PRIVATE KEY
                    if let decrypted_iv = RSAKeyPair(private_key: private_sec_key, public_key: public_sec_key).decrypt(data: encrypted_iv_data),
                       let decrypted_key = RSAKeyPair(private_key: private_sec_key, public_key: public_sec_key).decrypt(data: encrypted_key_data) {
                        
                        if let string_iv = String(data:decrypted_iv,encoding: .utf8) ,
                           let string_key = String(data:decrypted_key,encoding: .utf8) {
                            
                            print("\nDECRYPTED IV - \(String(data:decrypted_iv,encoding: .utf8) ?? "")\n")
                            print("\nDECRYPTED KEY - \(String(data:decrypted_key,encoding: .utf8) ?? "")\n")
                            
                            // DECRYPT DATA FROM IV AND KEY
                            if let decrypted_data  = AES256Key.decryptData(encryptedData: data, symmetricKey: string_key, iv: string_iv) {
                                
                                print("\nDECRYPTED RESPONSE : \(decrypted_data)\n")
                                
                                let jsonString = """
                                                    \(decrypted_data)
                                                    """
                                
                                // CONVERT DATA INTO JSON AND DECODE IT TO MODEL CLASS
                                self.convertResponseToDecoder(decoder,jsonString: jsonString) { isSuccess, responseModel, error_message in
                                    if isSuccess {
                                        completion(true, responseModel, error_message)
                                    } else {
                                        completion(false, responseModel , error_message)
                                    }
                                }
                                
                            } else {
                                print("\nError in data from decrypted iv and key \n")
                                BaseViewController().logoutUser(message: Message.multiple_device_found())
                                completion(false,nil,nil)
                            }
                        } else {
                            print("\nError in converting string from decrypted iv and or decrypted key \n")
                            BaseViewController().logoutUser(message: Message.multiple_device_found())
                            completion(false,nil,nil)
                        }
                    } else {
                        print("\nError in decrypt iv or decrypt key from encrypted_iv_data \n")
                        BaseViewController().logoutUser(message: Message.multiple_device_found())
                        completion(false,nil,nil)
                    }
                }
            } else {
                print("\nError in generate SecKey from private_key or public_key \n")
                completion(false,nil,Message.something_went_wrong())
            }
        } else {
            print("\nError private_key or public_key not found from Keychain \n")
            completion(false,nil,Message.something_went_wrong())
        }
    }
    
    
    /// Use this function to convert model class from response string
    fileprivate func convertResponseToDecoder<T: Decodable>(_ decoder: T.Type, jsonString: String, completion: @escaping (_ isSuccess: Bool, T?, _ errorMessage: String?) -> Void) {
        if let data = jsonString.data(using: String.Encoding.utf8) {
            do {
                let object = try JSONDecoder().decode(decoder, from: data)
                
                let dictData = jsonString.toDictionary()
                let message = dictData?["message"] as? String
                let status = dictData?["status"] as? Int
                
                if status == 200 {
                    completion(true, object, message ?? "")
                    
                } else if status == 401 {
                    BaseViewController().logoutUser(message: message)
                }
                else {
                    completion(false, object, message ?? Message.something_went_wrong())
                }
            }
            catch(let err) {
                print("\nError decoding JSON: \(err.localizedDescription)\n")
                completion(false, nil, Message.something_went_wrong())
            }
        } else {
            completion(false, nil, Message.something_went_wrong())
        }
    }
}
