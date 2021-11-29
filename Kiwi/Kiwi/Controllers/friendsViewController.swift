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
        loadUI()
    }
    
    
    func loadUI() {
        let email = Auth.auth().currentUser?.email
        self.db.collection("friends").addSnapshotListener { querySnapshot, error in
            if let e = error {
                print("There was an error retrieving data: \(e)")
            } else{
                self.friends = []
                if let snapshotDocs = querySnapshot?.documents {
                    for doc in snapshotDocs{
                        let data = doc.data()
                        if data["email"] as? String == email{
                            let friendEmail = data["friendEmail"] as! String
                            let friendName = friendEmail.components(separatedBy: "@")[0]
                            var favCoins: [String] = []
                            self.db.collection("favCrypto").addSnapshotListener { querySnapshot, error in
                                if let e = error {
                                    print("There was an error retrieving data: \(e)")
                                } else{
                                    if let snapshotDocs = querySnapshot?.documents {
                                        for doc in snapshotDocs{
                                            let data = doc.data()
                                            if data["email"] as? String == friendEmail{
                                                favCoins.append(data["coin"] as! String)
                                            }
                                        }
                                    }
                                    let newFriend = Friend(email: friendEmail, nickname: friendName, favCoins: favCoins)
                                    self.friends.append(newFriend)
                                    DispatchQueue.main.async {
                                        self.cardTableView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func friendAdded(_ sender: UIButton) {
        if let friendMail = friendEmail.text, let userEmail = Auth.auth().currentUser?.email {
            if friendMail != "" {
                self.db.collection("registeredUsers").addSnapshotListener { querySnapshot, error in
                    if let e = error {
                        print("There was an error retrieving data: \(e)")
                    } else{
                        if let snapshotDocs = querySnapshot?.documents {
                            var userFound = false
                            for doc in snapshotDocs{
                                let data = doc.data()
                                if data["email"] as? String == friendMail{
                                    self.db.collection("friends").addDocument(data: [
                                        "email": userEmail,
                                        "friendEmail": friendMail
                                    ]) { err in
                                        if let err = err {
                                            print("Error adding document: \(err)")
                                        }
                                    }
                                    userFound = true
                                }
                            }
                            if (userFound == false){
                                let alertController = UIAlertController(title: "Alert", message: "Invalid email address!", preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: .default) {
                                    (action: UIAlertAction!) in
                                }
                                alertController.addAction(OKAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }}}
            }
        }
        friendEmail.text = ""
    }
}


extension friendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cardTableView.dequeueReusableCell(withIdentifier: "friendCellIdentifier") as! friendTableViewCell
        cell.friendEmail.text = friends[indexPath.row].nickname
        
        let favoriteCoins = friends[indexPath.row].favCoins
        let favoriteCoinsString = favoriteCoins.joined(separator: ", ")
        
        cell.friendCoins.text = favoriteCoinsString
        if (cell.friendCoins.text == ""){
            cell.friendCoins.text = "\(friends[indexPath.row].nickname)'s watchlist is empty!"
        }
        cell.configure()
        return cell
    }
    
    
}
