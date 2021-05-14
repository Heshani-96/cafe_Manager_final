//
//  inputValidator.swift
//  cafe_Manager_final
//
//  Created by Heshani Chamalka on 2021-05-10.
//

import Foundation
class inputValidator {
    
    static let emailRegEx = "[A-Z0-9a-z,_%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let nameRegEx = "[A-Za-z ]{2,100}"
    static let mobileRegEx = "^(07)(0|1|2|5|6|7|8)[\\d]{7}$"
    
    static func isValidEmai(email: String) -> Bool {
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func isValidName(name: String) -> Bool {
        let compRegEx = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
        return compRegEx.evaluate(with: name)
    }
    
    static func isValidPassword(password: String, minLength: Int, maxLength: Int) -> Bool {
        return password.count >= minLength && password.count <= maxLength
    }
    
    static func isValidMobile(mobile: String) -> Bool {
        let mobilePred = NSPredicate(format: "SELF MATCHES %@", mobileRegEx)
        return mobilePred.evaluate(with: mobile)
    }
    
//    static func isValidFoodName(foodName: String) -> Bool {
//        let compRegEx = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
//        return compRegEx.evaluate(with: foodName)
//    }
    
    
    
}
