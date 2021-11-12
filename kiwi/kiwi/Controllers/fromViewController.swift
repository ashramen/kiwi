//
//  fromViewController.swift
//  kiwi
//
//  Created by Tristin Morse on 11/9/21.
//

import UIKit

class fromViewController: UIViewController {
    override func viewDidLoad() {
            super.viewDidLoad()


        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! usernameViewController
        if segue.identifier == "choseSpotify" {
            dest.chosen = "spotify"
        }
        if segue.identifier == "choseApple"{
            dest.chosen = "apple"
        }
    }
    
}



