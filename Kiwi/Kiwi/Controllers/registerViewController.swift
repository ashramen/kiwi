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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
