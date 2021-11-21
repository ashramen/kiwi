//
//  mainViewController.swift
//  mainViewController
//
//  Created by student on 11/16/21.
//

import UIKit
import Firebase

class mainViewController: UIViewController {
    @IBOutlet weak var coinSearchText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    let cellIdentifier = "coinIdentifier"
    let coinAPI = CoinAPI()
    
    var coins: [Coin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        self.tabBarController?.navigationItem.hidesBackButton = true
        loadUI()
    }
    
    func loadUI() {
        let email = Auth.auth().currentUser?.email
        db.collection("favCrypto").order(by: "coin").addSnapshotListener { querySnapshot, error in
            if let e = error {
                print("There was an error retrieving data: \(e)")
            } else{
                self.coins = []
                if let snapshotDocs = querySnapshot?.documents {
                    for doc in snapshotDocs{
                        let data = doc.data()
                        if data["email"] as? String == email{
                            let coin = data["coin"] as? String
                            let rate = self.coinAPI.getCoinPrice(coin: coin ?? "none", currency: "USD")
                            let newCoin = Coin(name: coin ?? "none", rate: rate)
                            self.coins.append(newCoin)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }

                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func searchBtn(_ sender: UIButton) {
        if let coinName = coinSearchText.text, let userEmail = Auth.auth().currentUser?.email {
            if coinName != ""{
                db.collection("favCrypto").addDocument(data: [
                    "email": userEmail,
                    "coin": coinName,
                    "date": Date().timeIntervalSince1970
                ]) { error in
                    if let e = error {
                        print("Data was not successfully saved, error: \(e)")
                    } else {
                        print("Successfully saved data!")
                    }
                }
            }
            
        }
        //        let coinPrice = coinAPI.getCoinPrice(coin: coinName ?? "BTC", currency: "USD")
        coinSearchText.text = ""
    }
    
    //    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
    //        let firebaseAuth = Auth.auth()
    //    do {
    //      try firebaseAuth.signOut()
    //        navigationController?.popToRootViewController(animated: true)
    //    } catch let signOutError as NSError {
    //      print("Error signing out: %@", signOutError)
    //    }
    //
    //    }
    
    
}

extension mainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = coins[indexPath.row].name
        return cell
    }
}
