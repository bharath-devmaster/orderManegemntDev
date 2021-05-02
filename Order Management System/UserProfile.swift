//
//  UserProfile.swift
//  Order Management System
//
//  Created by Apalya on 25/04/21.
//

import UIKit

class UserProfile: NSObject,NSCoding {

    var userName:String
    var userPassword:String
    var remembermeEnabled:Bool
    
    init(name :String, password: String, rememberMe:Bool) {
        self.userName = name
        self.userPassword = password
        self.remembermeEnabled = rememberMe
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(userName, forKey: "userName")
        coder.encode(userPassword, forKey: "userPassword")
        coder.encode(remembermeEnabled, forKey: "remembermeEnabled")

    }
    
    required init?(coder: NSCoder) {
        userName = coder.decodeObject(forKey: "userName") as? String ?? ""
        userPassword = coder.decodeObject(forKey: "userPassword") as? String ?? ""
        remembermeEnabled = coder.decodeObject(forKey: "remembermeEnabled") as? Bool ?? false
    }
    
    func SavePofileDataInUserDefaults(){
        do{
            let encodedObject : NSData = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false) as NSData
            let defaults : UserDefaults = UserDefaults.standard
            defaults.set(encodedObject, forKey: "UserData")
            defaults.synchronize()
            
        } catch{
            print("error in saving USER DATA in Defaults")
        }
        print(self.userName)
        print(self.userPassword)
        print(self.remembermeEnabled)
    }
    
//    func getUserProfiles() -> self  {
//        var profile:UserProfile? = nil
//
//        do{
//
//        let defaults : UserDefaults = UserDefaults.standard
//        let encodedData:NSData = defaults.object(forKey: "UserData") as! NSData
//            profile = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(encodedData as Data) as? UserProfile
//        }catch{
//            print("error in fetching USER DATA from Defaults")
//        }
//
//        return profile ?? profile!
//    }
    
}

