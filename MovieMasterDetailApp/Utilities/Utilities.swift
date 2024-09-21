//
//  Utilities.swift
//  MovieMasterDetailApp
//
//  Created by Muhammad Irfan Awan on 21/09/2024.
//

import Foundation




class UserInfoUtilities<T: Codable> {
    // Load customer information from user default
    class func loadModelFromUserDefaults(key: String) -> (hasInfo: Bool, usersInfo: T?) {
        let userDefaults = UserDefaults.standard
        if let userData = userDefaults.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode(T.self, from: userData) {
                return (true, decodedData)
            }
        }
        return (false, nil)
    }
    
    class func saveModelInUserDefaults(key: String, userInfo: T?) {
        let userDefaults = UserDefaults.standard
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userInfo) {
            userDefaults.set(encoded, forKey: key)
        }
        userDefaults.synchronize()
    }
}
