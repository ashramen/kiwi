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
    var sortedCoins: CoinAssets = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Home"
        tableView.dataSource = self
        self.tabBarController?.navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: "coinTableViewCell", bundle: nil), forCellReuseIdentifier: "coinCell")
        
        // Load all the coins from the API and Define in AllCoins
        coinAPI.getCoinAssets() { (CoinAssets) in
            self.allCoins = CoinAssets
            print("Total Coins Loaded: ", self.allCoins.count)
        
        // Test to see that the coins were loaded in descending order (volume1DayUsd)
        /*for n in 0...40 {
            print(self.allCoins[n].assetID, " - volume1DayUsd: ", self.allCoins[n].volume1DayUsd)
        }*/
            
        }
        
        
    }
    
    
}

extension mainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell", for: indexPath) as! coinTableViewCell
        cell.coinName.text = "Coin"
        return cell
    }
}
