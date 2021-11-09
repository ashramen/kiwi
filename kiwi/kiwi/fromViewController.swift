//
//  fromViewController.swift
//  kiwi
//
//  Created by Tristin Morse on 11/9/21.
//

import UIKit

class fromViewController: UIViewController {

    @IBOutlet weak var connectAccount: UIButton!
    @IBOutlet weak var appleMusicChoose: UIImageView!
    @IBOutlet weak var spotifyChoose: UIImageView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            // create tap gesture recognizer
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(fromViewController.imageTapped(gesture:)))

            // add it to the image view;
            spotifyChoose.addGestureRecognizer(tapGesture)
            // make sure imageView can be interacted with by user
            spotifyChoose.isUserInteractionEnabled = true
        }

        @objc func imageTapped(gesture: UIGestureRecognizer) {
            // if the tapped view is a UIImageView then set it to imageview
            if (gesture.view as? UIImageView) != nil {
                print("Image Tapped")
                //Here you can initiate your new ViewController

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
