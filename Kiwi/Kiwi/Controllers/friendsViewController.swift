//
//  friendsViewController.swift
//  friendsViewController
//
//  Created by student on 11/21/21.
//

import UIKit
import Firebase

class friendsViewController: UIViewController {
    
    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet weak var friendEmail: UITextField!
    
    let db = Firestore.firestore()
    var friends: [Friend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Friends"
        self.tabBarController?.navigationItem.hidesBackButton = true
        cardTableView.dataSource = self
    }
    
    @IBAction func friendAdded(_ sender: UIButton) {
        if let friendMail = friendEmail.text, let userEmail = Auth.auth().currentUser?.email {
            if friendMail != "" {
                db.collection("friends").document(userEmail).setData([
                    "friendEmail": friendMail
                ])
            }
            else {
                let alertController = UIAlertController(title: "Alert", message: "Please enter a friend's email address!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) {
                    (action: UIAlertAction!) in
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
    }}

extension friendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cardTableView.dequeueReusableCell(withIdentifier: "friendCellIdentifier") as! friendTableViewCell
        cell.friendEmail.text = "ash@gmail.com"
        cell.friendCoins.text = "ETH, BTC"
        cell.configure()
        return cell
    }
    
    
}
