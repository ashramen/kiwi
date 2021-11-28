//
//  mainViewController.swift
//  mainViewController
//
//  Created by student on 11/21/21.
//

import UIKit

class mainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let coinAPI = CoinAPI()
    var allCoins: CoinAssets = []
    var popCoins: CoinAssets = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Home"
        tableView.dataSource = self
        self.tabBarController?.navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: "coinTableViewCell", bundle: nil), forCellReuseIdentifier: "coinCell")
        
        // Load all the coins from the API and Define in AllCoins
        coinAPI.getCoinAssets() { (CoinAssets) in
            self.allCoins = CoinAssets
            
            var count: Int = 0
            while(self.popCoins.count < 20) {
                
                if (self.allCoins[count].typeIsCrypto == 1 && self.allCoins[count].priceUsd != nil) {
                    self.popCoins.append(self.allCoins[count])
                }
                count += 1
            }
            print("Total Coins Loaded: ", self.allCoins.count)
            print("Total Popular Coins : ", self.popCoins.count)
            //print(self.popCoins[0], "\n")
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
        /* Test to see that the coins were loaded in descending order (volume1DayUsd)
        for n in 0...40 {
            print(self.allCoins[n].assetID, " - volume1DayUsd: ", self.allCoins[n].volume1DayUsd)
        }*/
        }
        
        
        
        
    }
    
    
}

extension mainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell", for: indexPath) as! coinTableViewCell
        //let price = allCoins[indexPath.row].priceUsd!
        print("PopCoins Tableview: ", popCoins[indexPath.row].assetID)
        print("PopCoins Tableview: ", popCoins[indexPath.row])

        cell.coinName.text = popCoins[indexPath.row].name
        cell.coinSymbol.text = popCoins[indexPath.row].assetID

        //cell.coinPrice.text = String(price)
        //cell.coinPrice.text = String(price)
        
        
        return cell
    }
}
