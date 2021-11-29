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
    var allIcons: CoinIcons = []
    var urlMap: [String: String] = [:]
    var imageMap: [String: UIImage] = [:]
    
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
            self.coinAPI.getCoinAssetIcons() { [self] (CoinIcons) in
                
                // Create the url Map
                self.allIcons = CoinIcons
                for icon in self.allIcons {
                    self.urlMap[icon.assetID] = icon.url
                }
                
                for coin in self.coins {
                    let assetID = coin.name
                    let url = URL(string: urlMap[assetID] ?? "https://i.imgur.com/66HX61V.png")
                    let data = try? Data(contentsOf: url!)
                    
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        self.imageMap[assetID] = image
                    }
                }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
                    db.collection("favCrypto").document(coinName).setData([
                        "email": userEmail,
                        "coin": coinName,
                        "date": Date().timeIntervalSince1970])
                } }
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

        coinSearchText.text = ""
    }




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
        cell.coinPrice.text = "$" + String(format: "%.3f", price!)

        let coinIcon: UIImage = imageMap[coins[indexPath.row].name] ?? UIImage(named: "Logo")!
        
        cell.coinImage.image = coinIcon
        return cell
    }

    // MARK: - Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let coinDelete = self.coins[indexPath.row].name
            self.coins.remove(at: indexPath.row)
            db.collection("favCrypto").document(coinDelete).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }

            tableView.reloadData()

        }
    }
}
