//
//  fromViewController.swift
//  kiwi
//
//  Created by Tristin Morse on 11/9/21.
//

import UIKit

class fromViewController: UIViewController {
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var appleMusicChoose: UIButton!
    @IBOutlet weak var spotifyChoose: UIButton!
    
    let spotifyImg = UIImage(named: "spotifyImage")
    var chosenBtn: String = ""
    
    override func viewDidLoad() {
            super.viewDidLoad()


        }
    
    @IBAction func playlistChosen(_ sender: UIButton) {
        if (sender == spotifyChoose){
            chosenBtn = "spotify"
        } 
        if (sender == appleMusicChoose){
            chosenBtn = "apple"
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
