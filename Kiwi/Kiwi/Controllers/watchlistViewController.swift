//
//  mainViewController.swift
//  mainViewController
//
//  Created by student on 11/16/21.
//

import UIKit
import Firebase

class watchlistViewController: UIViewController {
    @IBOutlet weak var coinSearchText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    let cellIdentifier = "coinIdentifier"
    let coinAPI = CoinAPI()
    
    var coins: [Coin] = []
    
    var allCoins: CoinAssets = []
    var coinMap: [String: CoinAsset] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Watchlist"
        tableView.dataSource = self
        self.tabBarController?.navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: "coinTableViewCell", bundle: nil), forCellReuseIdentifier: "coinCell")
        loadUI()
    }
    
    func loadUI() {
        
        coinAPI.getCoinAssets() { (CoinAssets) in
            self.allCoins = CoinAssets
            for coin in self.allCoins {
                self.coinMap[coin.assetID] = coin
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        print("coins count 1... ", self.coins.count)
        print("coinMap count... ", self.coinMap.count)
        
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
                            
//                            let rate = self.coinAPI.getCoinPrice(coin: coin ?? "none", currency: "USD")
//                            let newCoin = Coin(name: coin ?? "none", rate: rate)
//                            self.coins.append(newCoin)
//                            DispatchQueue.main.async {
//                                self.tableView.reloadData()
//                            }

                        }
                    }
                    print(self.coins)
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
            DispatchQueue.main.async {
                self.tableView.reloadData()
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

extension watchlistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell", for: indexPath) as! coinTableViewCell
        cell.coinName.text = coins[indexPath.row].name_full
        cell.coinSymbol.text = coins[indexPath.row].name
        let price = Double(coins[indexPath.row].rate)
        cell.coinPrice.text = String(format: "%.3f", price as! CVarArg)
        
        return cell
    }
}
