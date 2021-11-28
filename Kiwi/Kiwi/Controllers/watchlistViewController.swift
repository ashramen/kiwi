//
//  mainViewController.swift
//  mainViewController
//
//  Created by student on 11/16/21.
//

import UIKit
import Firebase

// MARK: - UIViewController Class
class watchlistViewController: UIViewController {
    @IBOutlet weak var coinSearchText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    let cellIdentifier = "coinIdentifier"
    let coinAPI = CoinAPI()
    
    var coins: [Coin] = []
    
    var allCoins: CoinAssets = []
    var coinMap: [String: CoinAsset] = [:]
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Watchlist"
        tableView.dataSource = self
        self.tabBarController?.navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: "coinTableViewCell", bundle: nil), forCellReuseIdentifier: "coinCell")
        loadUI()
    }
    
    // MARK: - LoadUI
    func loadUI() {
        
        coinAPI.getCoinAssets() { (CoinAssets) in
            self.allCoins = CoinAssets
            for coin in self.allCoins {
                self.coinMap[coin.assetID] = coin
            }
            
            // Test Print that coins have been generated and added to Map
            //print("coinMap count... ", self.coinMap.count)
            
            let email = Auth.auth().currentUser?.email
            self.db.collection("favCrypto").order(by: "coin").addSnapshotListener { querySnapshot, error in
                if let e = error {
                    print("There was an error retrieving data: \(e)")
                } else{
                    self.coins = []
                    if let snapshotDocs = querySnapshot?.documents {
                        for doc in snapshotDocs{
                            let data = doc.data()
                            if data["email"] as? String == email{
                                let coin_name = data["coin"] as? String
                                if self.coinMap.keys.contains(coin_name!) {
                                    let coinPrice = self.coinMap[coin_name ?? "none"]!.priceUsd
                                    let coinNameFull = self.coinMap[coin_name ?? "none"]!.name
                                    let newCoin = Coin(name: coin_name ?? "none", rate: String(coinPrice ?? 0), name_full: coinNameFull)
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
        }
    }
    
    // MARK: - SearchBtn
    @IBAction func searchBtn(_ sender: UIButton) {
        
        var coinNameList: [String] = []
        for coin in self.coins {
            coinNameList.append(coin.name)
        }

        if let coinName = coinSearchText.text, let userEmail = Auth.auth().currentUser?.email {
            if self.coinMap[coinName]?.priceUsd != nil && coinNameList.contains(coinName) == false {
                print(coinName, self.coinMap[coinName]?.priceUsd ?? 0.0)
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
            else if coinNameList.contains(coinName) == true {
                let alertController = UIAlertController(title: "Alert", message: "You have already saved this cryptocurrency!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) {
                    (action: UIAlertAction!) in
                    // Code in this block will trigger when OK button tapped.
                    print("Ok button tapped");
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                let alertController = UIAlertController(title: "Alert", message: "This is not a real cryptocurrency!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) {
                    (action: UIAlertAction!) in
                    // Code in this block will trigger when OK button tapped.
                    print("Ok button tapped");
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
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

// MARK: - TableView Controller
extension watchlistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell", for: indexPath) as! coinTableViewCell
        cell.coinName.text = coins[indexPath.row].name_full
        cell.coinSymbol.text = coins[indexPath.row].name
        let price = Double(coins[indexPath.row].rate)
        cell.coinPrice.text = String(format: "%.3f", price!)
        
        return cell
    }
    
    // MARK: - Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            //let coinDelete = self.coins[indexPath.row].name
            self.coins.remove(at: indexPath.row)
//            if let coinName = coinSearchText.text, let userEmail = Auth.auth().currentUser?.email {
//            
//                db.collection("favCrypto").document(data: [
//                    "email": userEmail,
//                    "coin": coinDelete,
//                ]).delete() { err in
//                    if let err = err {
//                        print("Error removing document: \(err)")
//                    } else {
//                        print("Document successfully removed!")
//                    }
//                }
//            }
            tableView.reloadData()
            
        }
    }
}
