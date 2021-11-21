//
//  loginViewController.swift
//  loginViewController
//
//  Created by student on 11/16/21.
//

import UIKit
import Firebase

class loginViewController: UIViewController {
    @IBOutlet weak var emailBox: UITextField!
    @IBOutlet weak var passwordBox: UITextField!
    @IBOutlet weak var loginBox: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginBox.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        loginBox.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        loginBox.layer.shadowOpacity = 1.0
        loginBox.layer.shadowRadius = 0.0
        loginBox.layer.masksToBounds = false
        loginBox.layer.cornerRadius = 5
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        if let email = emailBox.text, let password = passwordBox.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let err = error {
                    print(err.localizedDescription)
                } else{
                    self.performSegue(withIdentifier: "loginToHome", sender: self)
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
