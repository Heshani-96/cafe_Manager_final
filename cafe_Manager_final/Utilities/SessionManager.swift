//
//  SessionManager.swift
//  cafe_Manager_final
//
//  Created by Heshani Chamalka on 2021-05-10.
//

import Foundation

class SessionManager {
    
    func getLoggedState() -> Bool {
     return UserDefaults.standard.bool(forKey: "LOGGED_IN")
  
    }
    
    func saveUserLogin(admin: Admin) {
        UserDefaults.standard.setValue(true, forKey: "USER_LOGGED")
        UserDefaults.standard.setValue(admin.userName, forKey: "USER_NAME")
        UserDefaults.standard.setValue(admin.email, forKey: "USER_EMAIL")
        UserDefaults.standard.setValue(admin.phoneNo, forKey: "USER_PHONENO")

    }
    func getUserData() -> Admin{
        let admin = Admin(userName: UserDefaults.standard.string(forKey: "USER_NAME") ?? "",
                        email: UserDefaults.standard.string(forKey: "USER_EMAIL") ?? "",
                        password: "",
                        phoneNo: UserDefaults.standard.string(forKey: "USER_PHONENO") ?? "")
        return admin
        
    }

    func clearUserLoggedState(){
        UserDefaults.standard.setValue(false, forKey: "LOGGED_IN")
    }
    
}
