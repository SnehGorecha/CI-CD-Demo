//
//  KeyGenerator.swift
//  AddressFull
//
//  Created by MacBook Pro  on 30/10/23.
//

import Foundation
import CommonCrypto


private enum EncryptionConstants {
    static let rsaKeySizeInBits: NSNumber = 4096
    static let iv128KeySize: Int = kCCKeySizeAES128
    static let aes256KeySize: Int = kCCKeySizeAES256
    static let aesAlgorithm: CCAlgorithm = CCAlgorithm(kCCAlgorithmAES128)
    static let aesOptions: CCOptions = CCOptions(kCCOptionPKCS7Padding)
    static let rsaAlgorithm: SecKeyAlgorithm = .rsaEncryptionPKCS1
}


///
/// The namespace responsible for cryptographic work in `Encryption`
///
public enum Encryption {
    ///
    /// Will create a brand new AES private key for symmetric cryptography. Will not
    /// store the key anywhere special (i.e. Keychain), but only stores the new
    /// key in memory and returns.
    ///
    public static func generateRandomAES256Key() -> AES256Key? {
        func makeSecRandomData(_ count: Int) -> Data? {
            var result = [UInt8](repeating: 0, count: count)
            if SecRandomCopyBytes(kSecRandomDefault, count, &result) != 0 {
                return nil
            }
            return Data(result)
        }
        if let iv = makeSecRandomData(EncryptionConstants.iv128KeySize), let aes256Key =
            makeSecRandomData(EncryptionConstants.aes256KeySize) {
            print("\nNew IV - \(iv.toString() ?? "")")
            print("\nNew Key - \(aes256Key.toString() ?? "")\n")
            return AES256Key(iv: iv, aes256Key: aes256Key)
        } else {
            return nil
        }
        
    }
    ///
    /// Will create a brand new RSA private and public key pair for asymmetric
    /// cryptography. Will not store the key pair anywhere special (i.e. Keychain),
    /// but only stores the new key in memory and returns.
    ///
    public static func generateRandomRSAKeyPair() -> RSAKeyPair? {
        let privateAttributes: [NSObject : Any] = [
            kSecAttrIsPermanent: false
        ]
        let publicAttributes: [NSObject : Any] = [:]
        let pairAttributes: [NSObject : Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits: EncryptionConstants.rsaKeySizeInBits,
            kSecPublicKeyAttrs: publicAttributes,
            kSecPrivateKeyAttrs: privateAttributes
        ]
        
        var error: Unmanaged<CFError>?
        if let private_key: SecKey = SecKeyCreateRandomKey(pairAttributes as CFDictionary, &error),
           let public_key: SecKey = SecKeyCopyPublicKey(private_key) {
            if error != nil {
                return nil
            } else {
                return RSAKeyPair(private_key: private_key, public_key: public_key)
            }
        } else {
            return nil
        }
    }
    
    
    /// Use this function to encrypt data using Iv and Key
    public static func encryptDataFromIvAndKey(from data: Data) -> (iv: Data?,key: Data?,encrypted_data: Data?) {
        let random_aes_key = Encryption.generateRandomAES256Key()
        
        if let iv = random_aes_key?.iv,
           let key = random_aes_key?.aes256Key {
            
            let encrypted_data = AES256Key(iv: iv, aes256Key: key).encryptData(data: data)
            return (iv,key,encrypted_data)
        } else {
            return (nil,nil,nil)
        }
    }
    
    
    /// Use this function to encrypt Iv and Key using server public key
    public static func encryptIvAndKeyFromPublicKey(iv: Data,key: Data) -> (encrypted_iv: Data?, encrypted_key: Data?) {
            if let public_key = KeyChain().load(key: KeyChainKey.server_public_key, group: KeyChainKey.group) {
                if let sec_public_key = SecKey.loadFromData(public_key, isForPrivateKey: false) {
                    let enrcypted_iv = RSAPublicKey(publicKey: sec_public_key).encrypt(data: iv)
                    let enrcypted_key = RSAPublicKey(publicKey: sec_public_key).encrypt(data: key)
                    return (enrcypted_iv,enrcypted_key)
                }
            }
        return (nil,nil)
    }
    
    
    /// Use this function to create request string seperated with pipe
    public static func createFinalStringForApiRequest(from encrypted_data: Data,encrypted_iv: Data,encrypted_key: Data) -> String {
        if let string_data = encrypted_data.toString(),
           let string_key = encrypted_key.toString(),
           let stirng_iv = encrypted_iv.toString() {
            return "\(string_data)|\(string_key)|\(stirng_iv)|10$"
        } else {
            return ""
        }
    }
    
    
    /// Use this function to remove BEGIN , END and "|"(PIPE)  from pubic key
    public static func removeBeginAndEndFromPublicKey(key: String) -> String {
        return key
            .replacingOccurrences(of: "-----BEGIN PUBLIC KEY-----", with: "")
            .replacingOccurrences(of: "-----END PUBLIC KEY-----", with: "")
            .replacingOccurrences(of: "|", with: "")
    }
}

///
/// The AES key. Contains both the initialization vector and secret key.
///
public struct AES256Key {
    /// Initialization vector
    let iv: Data
    let aes256Key: Data
#if DEBUG
    public var __debug_iv: Data { iv }
    public var __debug_aes256Key: Data { aes256Key }
#endif
    init(iv: Data, aes256Key: Data) {
        self.iv = iv
        self.aes256Key = aes256Key
    }
    ///
    /// Takes the data and uses the private key to encrypt it. Will call `CCCrypt` in CommonCrypto
    /// and provide it `ivData` for the initialization vector. Will use cipher block chaining (CBC) as
    /// the mode of operation.
    ///
    /// Returns the encrypted data.
    ///
    public func encryptData(data: Data) -> Data? {
        var encryptedBytes = [UInt8](repeating: 0, count: data.count + kCCBlockSizeAES128)
        var numBytesEncrypted: size_t = 0
        
        let status = aes256Key.withUnsafeBytes { keyBytes in
            iv.withUnsafeBytes { ivBytes in
                data.withUnsafeBytes { inputBytes in
                    CCCrypt(
                        CCOperation(kCCEncrypt),
                        EncryptionConstants.aesAlgorithm,
                        EncryptionConstants.aesOptions,
                        keyBytes.baseAddress,
                        aes256Key.count,
                        ivBytes.baseAddress,
                        inputBytes,
                        data.count,
                        &encryptedBytes,
                        encryptedBytes.count,
                        &numBytesEncrypted
                    )
                }
            }
        }
        
        guard status == kCCSuccess else {
            return nil
        }
        
        let encryptedData = Data(bytes: encryptedBytes, count: numBytesEncrypted)
        return encryptedData
    }
    
    ///
    /// Takes the data and uses the private key to decrypt it. Will call `CCCrypt` in CommonCrypto
    /// and provide it `ivData` for the initialization vector. Will use cipher block chaining (CBC) as
    /// the mode of operation.
    ///
    /// Returns the decrypted data.
    ///
    public static func decryptData(encryptedData: String, symmetricKey: String, iv: String) -> String? {
        guard let symmetricKeyData = Data(base64Encoded: symmetricKey),
              let ivData = Data(base64Encoded: iv),
              let encryptedData = Data(base64Encoded: encryptedData) else {
            return nil
        }
        
        let decryptedData = Data(count: encryptedData.count + kCCBlockSizeAES128)
        var decryptedDataLength = 0
        
        var localDecryptedData = decryptedData
        
        let status = symmetricKeyData.withUnsafeBytes { symmetricKeyBytes in
            ivData.withUnsafeBytes { ivBytes in
                encryptedData.withUnsafeBytes { encryptedBytes in
                    localDecryptedData.withUnsafeMutableBytes { decryptedBytes in
                        CCCrypt(
                            CCOperation(kCCDecrypt),
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionPKCS7Padding),
                            symmetricKeyBytes.baseAddress,
                            kCCKeySizeAES256,
                            ivBytes.baseAddress,
                            encryptedBytes.baseAddress,
                            encryptedData.count,
                            decryptedBytes.baseAddress,
                            decryptedData.count,
                            &decryptedDataLength
                        )
                    }
                }
            }
        }
        
        if status == kCCSuccess {
            localDecryptedData.removeSubrange(decryptedDataLength..<localDecryptedData.count)
            return String(data: localDecryptedData, encoding: .utf8)
        } else {
            return nil
        }
    }
    
    ///
    /// Allows you to export the RSA public key to a format (so you can send over the net).
    ///
    public func exportIvAndPrivateAES256Key() -> Data {
        return self.iv + self.aes256Key
    }
    
    
    ///
    /// Allows you to load an RSA public key (i.e. one downloaded from the net).
    ///
    public static func loadIvAndPrivateAES256Key(ivAndPrivateAES256Key: Data) -> AES256Key? {
        guard ivAndPrivateAES256Key.count == EncryptionConstants.aes256KeySize * 2 else {
            return nil
        }
        return AES256Key(
            iv: ivAndPrivateAES256Key[0 ..< EncryptionConstants.aes256KeySize],
            aes256Key: ivAndPrivateAES256Key[EncryptionConstants.aes256KeySize ..< EncryptionConstants.aes256KeySize*2]
        )
    }
}

///
/// The RSA keypair. Includes both private and public key.
///
public struct RSAKeyPair {
    private let private_key: SecKey
    private let public_key: SecKey
    
#if DEBUG
    public var __debug_privateKey: SecKey { self.private_key }
    public var __debug_publicKey: SecKey { self.public_key }
#endif
    
    init(private_key: SecKey, public_key: SecKey) {
        self.private_key = private_key
        self.public_key = public_key
    }
    
    public func extractPublicKey() -> RSAPublicKey {
        RSAPublicKey(publicKey: public_key)
    }
    
    public func extractPrivateKey() -> RSAPrivateKey {
        RSAPrivateKey(private_key: self.private_key)
    }
    
    ///
    /// Takes the data and uses the private key to decrypt it.
    /// Returns the decrypted data.
    ///
    public func decrypt(data: Data) -> Data? {
        var error: Unmanaged<CFError>?
        if let decryptedData: CFData = SecKeyCreateDecryptedData(self.private_key, EncryptionConstants.rsaAlgorithm, data as CFData, &error) {
            if error != nil {
                return nil
            } else {
                return decryptedData as Data
            }
        } else {
            return nil
        }
    }
}


///
/// The RSA public key.
///
public struct RSAPublicKey {
    private let publicKey: SecKey
    
#if DEBUG
    public var __debug_publicKey: SecKey { self.publicKey }
#endif
    
    fileprivate init(publicKey: SecKey) {
        self.publicKey = publicKey
    }
    ///
    /// Takes the data and uses the public key to encrypt it.
    /// Returns the encrypted data.
    ///
    public func encrypt(data: Data) -> Data? {
        var error: Unmanaged<CFError>?
        if let encryptedData: CFData = SecKeyCreateEncryptedData(self.publicKey, EncryptionConstants.rsaAlgorithm, data as CFData, &error) {
            if error != nil {
                return nil
            } else {
                return encryptedData as Data
            }
        } else {
            return nil
        }
    }
    
    
    ///
    /// Allows you to export the RSA public key to a format (so you can send over the net).
    ///
    public func export() -> Data? {
        return publicKey.exportToData()
    }
    
    
    ///
    /// Allows you to load an RSA public key (i.e. one downloaded from the net).
    ///
    public static func load(rsaPublicKeyData: Data) -> RSAPublicKey? {
        if let public_key: SecKey = .loadFromData(rsaPublicKeyData) {
            return RSAPublicKey(publicKey: public_key)
        } else {
            return nil
        }
    }
}

///
/// The RSA private key.
///
public struct RSAPrivateKey {
    private let privateKey: SecKey
    
#if DEBUG
    public var __debug_privateKey: SecKey { self.privateKey }
#endif
    
    fileprivate init(private_key: SecKey) {
        self.privateKey = private_key
    }
    
    
    ///
    /// Allows you to export the RSA public key to a format (so you can send over the net).
    ///
    public func export() -> Data? {
        return privateKey.exportToData()
    }
}

extension SecKey {
    func exportToData() -> Data? {
        var error: Unmanaged<CFError>?
        if let cf_data = SecKeyCopyExternalRepresentation(self, &error) {
            if error != nil {
                return nil
            } else {
                return cf_data as Data
            }
        } else {
            return nil
        }
    }
    static func loadFromData(_ data: Data,isForPrivateKey : Bool = false) -> SecKey? {
        let key_dict: [NSObject : NSObject] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: isForPrivateKey ? kSecAttrKeyClassPrivate : kSecAttrKeyClassPublic ,
            kSecAttrKeySizeInBits: EncryptionConstants.rsaKeySizeInBits
        ]
        return SecKeyCreateWithData(data as CFData, key_dict as CFDictionary, nil)
    }
}




class KeyEncryption  {
    
    
    /// Use this function to generate new public and private key
    func generateRSAKeyPair() -> (publicKey: Data, privateKey: Data)? {
        // Key size in bits
        let keySize = 4096
        
        // Create a dictionary to store the key pair attributes
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: keySize,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate
        ]
        
        // Create a new key pair
        var publicKey, privateKey: SecKey?
        let status = SecKeyGeneratePair(attributes as CFDictionary, &publicKey, &privateKey)
        
        guard status == errSecSuccess, let publicKeyData = SecKeyCopyExternalRepresentation(publicKey!, nil) as Data?,
              let privateKeyData = SecKeyCopyExternalRepresentation(privateKey!, nil) as Data?
        else {
            return nil
        }
        
        return (publicKey: publicKeyData, privateKey: privateKeyData)
    }
    
    
    /// Use this function to generate hashed device id
    public static func hashDeviceUDID(udid: String) -> String {
        guard let data = udid.data(using: .utf8) else {
            // Handle the case where the UDID cannot be converted to data
            return ""
        }
        
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        
        // Use the CommonCrypto framework to perform the SHA-256 hashing
        _ = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            CC_SHA256(bytes.baseAddress, CC_LONG(data.count), &hash)
        }
        
        // Convert the hashed data to a hexadecimal string
        let hashedString = hash.map { String(format: "%02hhx", $0) }.joined()
        
        return hashedString
    }
    
    
    public static func hashDeviceID(id: String) -> String? {
        let saltRounds = 10
        let salt = Data((0..<16).map { _ in UInt8.random(in: 0...255) })
        
        var derivedKey = [UInt8](repeating: 0, count: 16)
        
        let idData = Data(id.utf8)
        
        let derivationStatus = salt.withUnsafeBytes { saltBuffer in
            idData.withUnsafeBytes { passwordBuffer in
                CCKeyDerivationPBKDF(
                    CCPBKDFAlgorithm(kCCPBKDF2),
                    passwordBuffer.baseAddress!.assumingMemoryBound(to: Int8.self),
                    idData.count,
                    saltBuffer.baseAddress!.assumingMemoryBound(to: UInt8.self),
                    salt.count,
                    CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
                    UInt32(saltRounds),
                    &derivedKey,
                    derivedKey.count
                )
            }
        }
        
        guard derivationStatus == kCCSuccess else {
            return nil
        }
        
        let hashedPassword = Data(derivedKey).map { String(format: "%02hhx", $0) }.joined()
        
        return hashedPassword
    }
}
