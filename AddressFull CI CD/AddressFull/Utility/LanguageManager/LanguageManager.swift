//
//  LanguageManager.swift
//  AddressFull
//
//  Created by MacBook Pro  on 30/10/23.
//

import Foundation


class LanguageManager {
    static func setLanguage(_ languageCode: String) {
        UserDefaults.standard.set(languageCode, forKey: UserDefaultsKey.selected_language_key)
        UserDefaults.standard.synchronize()
    }
    
    static func getLanguage() -> String{
        if let lang = UserDefaults.standard.object(forKey: UserDefaultsKey.selected_language_key){
            return lang as! String
        }
       return "en"
    }
}
