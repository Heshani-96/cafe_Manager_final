//
//  signinViewController.swift
//  cafe_Manager_final
//
//  Created by Heshani Chamalka on 2021-05-10.
//

import UIKit
import Firebase
import Loaf

class signinViewController: UIViewController {
    var ref: DatabaseReference!


    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
}
    
    @IBAction func btnSignin(_ sender: UIButton) {
        
        if !inputValidator.isValidEmai(email: txtEmail.text ?? "") {
            Loaf("Invalid Email Address!!", state: .error, sender: self).show()
            return
        }
        
        if !inputValidator.isValidPassword(password: txtPassword.text ?? "", minLength: 6, maxLength: 15) {
            Loaf("Invalid Password!!", state: .error, sender: self).show()
            return
        }
        authenticateUser(email: txtEmail.text!, password: txtPassword.text!)
    }
 
    func authenticateUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {
            authResult, error in
            
            if let err = error{
                print(err.localizedDescription)
                Loaf("username or password is invalid", state: .error, sender: self).show()
                return
            }
            if let email = authResult?.user.email {
                self.getUserData(email: email)
            } else {
                Loaf("User email not found!!!", state: .error, sender: self).show()

            }
//            let sessionManager = SessionManager()
//            sessionManager.saveUserLogin()
//            self.performSegue(withIdentifier: "signInToHome", sender: nil)
            
        }
    }
    func getUserData(email: String) {
        ref.child("admin").child(email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        ).observe(.value, with: {
            (snapshot) in
            
            if snapshot.hasChildren() {
                if let data = snapshot.value {
                    if let userData = data as? [String: String] {
                    
                        let admin = Admin(
                                        userName: userData["name"]!,
                                        email: userData["email"]!,
                                        password: userData["password"]!,
                                        phoneNo: userData["phone"]! )
                        
                        let sessionManager = SessionManager()
                        sessionManager.saveUserLogin(admin: admin)
                        self.performSegue(withIdentifier: "signInToHome", sender: nil)
                    }
                }
            } else {
                Loaf("User not found!!!", state: .error, sender: self).show()
            }
        })
    }
}
