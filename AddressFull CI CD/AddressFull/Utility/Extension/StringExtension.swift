//
//  StringExtension.swift
//  Authentication
//
//  Created by MacBook Pro  on 13/09/23.
//

import Foundation


extension String {
    
    /// To check string object is blank or not
    var isBlank : Bool {
        let characterSet = CharacterSet.whitespacesAndNewlines.inverted
        let r = self.rangeOfCharacter(from: characterSet)
        return self.isEmpty || r == nil
    }
    
    /// To validate address format
    var isValidAddress : Bool {
        let addressRegEx = #"^\d+\s\w+(\s\w+)*$"#
        let addressPred = NSPredicate(format:"SELF MATCHES %@", addressRegEx)
        return addressPred.evaluate(with: self)
    }
    
    /// To validate email id format
    var isValidEmailID: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    /// To validate name format
    var isValidName: Bool {
        let nameRegEx = ".*[^A-Za-z ].*"
        let namePred = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: self)
    }
    
    
    /// To get localize text
    func localized() -> String {
        
        let path = Bundle.main.path(forResource: LanguageManager.getLanguage(), ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    
    /// Convert to Dictionary
    
    func toDictionary() -> [String : Any]? {
        
        if let jsonData = self.data(using: .utf8) {
            do {
                if let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    return jsonDictionary
                }
                else {
                    return nil
                }
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func toQueryParameter() -> String {
        return self.replacingOccurrences(of: "\"", with: "")
            .replacingOccurrences(of: " : ", with: "=")
            .replacingOccurrences(of: ",", with: "&")
            .replacingOccurrences(of: "{", with: "")
            .replacingOccurrences(of: "}", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "& ", with: "&")
    }
    
    func seperateByPipe() -> (encrypted_data: String, encrypted_key: String, encrypted_iv: String) {
        let seperatedString = self.split(separator: "|")
        if seperatedString.count > 2 {
            return ("\(seperatedString[0])","\(seperatedString[1])","\(seperatedString[2])")
        } else {
            return ("","","")
        }
    }
    
    func removeLastCharacter() -> String {
        var resultString = self
        
        resultString.removeLast()
        
        return resultString
    }
    
    func removeStarFromEnd() -> String {
        var resultString = self
        
        // Check if the string ends with '*'
        if resultString.hasSuffix("*") {
            // Remove the asterisk from the end
            resultString.removeLast()
        }
        
        return resultString
    }
    
    func removePlusFromBegin() -> String {
        var resultString = self
        
        // Check if the string ends with '*'
        if resultString.hasPrefix("+") {
            // Remove the asterisk from the end
            resultString.removeFirst()
        }
        
        return resultString
    }
    
    func isValidLinkedInURL() -> Bool {
        if let url = URL(string: self) {
            // Check if the URL has the expected host (linkedin.com) and path
            return url.host == "www.linkedin.com" && url.path.hasPrefix("/in/")
        }
        return false
    }
    
    func isValidTwitterURL() -> Bool {
        if let url = URL(string: self) {
            // Check if the URL has the expected host (twitter.com) and path
            return url.host == "x.com" || url.host == "twitter.com" && url.path.hasPrefix("/")
        }
        return false
    }
    
    func getCountryFlagFromCountryCode() -> String {
        return self
            .unicodeScalars
            .map({ 127397 + $0.value })
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
    
    func dialCode() -> String {
        Country.getCountryFromISOCode(from: self)?.dialCode ?? Country.getCurrentCountry()?.dialCode ?? ""
    }
}
