//
//  usernameViewController.swift
//  usernameViewController
//
//  Created by student on 11/12/21.
//

import UIKit

class usernameViewController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var enterUsername: UILabel!
    var userId: String = ""
    var chosen: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func `continue`(_ sender: UIButton) {
        userId = userTextField.text ?? "Not found"
        print(userId)
        print(chosen)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    

}
