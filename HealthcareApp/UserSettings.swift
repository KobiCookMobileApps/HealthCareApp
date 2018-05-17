//
//  UserSettings.swift
//  HealthcareApp
//
//  Created by Admin on 5/16/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation


class UserSettings {
    
    
    
    struct Keys {
        static let username = "username"
        static let service = "MyService"
        static let switchState = "switchState"
    }
    
    class func storedUserName() -> String? {
        return UserDefaults.standard.object(forKey: Keys.username) as? String
    }
    
    class func saveSwitchState() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.switchState)
    }
    
    
    class func saveUsername(_ username: String) {
        UserDefaults.standard.set(username, forKey: Keys.username)
    }
    
    
    
    class func saveLogin(username: String, password: String) {
        
        do {
            try KeychainPasswordItem(service: Keys.service, account: username ).savePassword(password)
            
            UserDefaults.standard.set(username, forKey: Keys.username)
            
        } catch {
            print ("Could not save login info")
        }

    }
    
    class func validateLogin(username: String, password: String) -> Bool {
        
        guard let storedUsername = storedUserName(), username == storedUsername  else {
            return false
        }
        
        guard let storedPassword = try? KeychainPasswordItem(service: Keys.service, account: username).readPassword() else {
            return false
        }
        
        return (password == storedPassword)
        
    }
    
    
    
    
}
