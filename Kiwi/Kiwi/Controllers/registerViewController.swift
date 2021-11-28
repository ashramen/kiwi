//
//  registerViewController.swift
//  registerViewController
//
//  Created by student on 11/16/21.
//

import UIKit
import Firebase

class registerViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var registerBox: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerBox.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        registerBox.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        registerBox.layer.shadowOpacity = 1.0
        registerBox.layer.shadowRadius = 0.0
        registerBox.layer.masksToBounds = false
        registerBox.layer.cornerRadius = 5
    }
    
    @IBAction func registerBtn(_ sender: UIButton) {
        if let email = emailText.text, let password = passwordText.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "registerToHome", sender: self)
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
