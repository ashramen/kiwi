//
//  mainViewController.swift
//  mainViewController
//
//  Created by student on 11/16/21.
//

import UIKit
import Firebase
class mainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Kiwi"
        navigationItem.hidesBackButton = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
        navigationController?.popToRootViewController(animated: true)
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
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
