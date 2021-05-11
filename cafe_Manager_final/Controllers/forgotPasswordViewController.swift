//
//  forgotPasswordViewController.swift
//  cafe_Manager_final
//
//  Created by Heshani Chamalka on 2021-05-10.
//

import UIKit
import Firebase
import Loaf

class forgotPasswordViewController: UIViewController {

    @IBOutlet weak var txtemail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnback(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnsubmit(_ sender: UIButton) {
    
        Auth.auth().sendPasswordReset(withEmail: txtemail.text!) { (error) in
            if error == nil {
                Loaf("Reset link send to the email", state: .success, sender: self).show()
            }
            else{
                Loaf("Failed!!\(error?.localizedDescription ?? "")", state: .error, sender: self).show()
            }
        }
    }
    
    @IBAction func btnDone(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)

    }
    
}
