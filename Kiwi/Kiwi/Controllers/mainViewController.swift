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
    
    var allIcons: CoinIcons = []
    var urlMap: [String: String] = [:]
    var imageMap: [String: UIImage] = [:]
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Home"
        tableView.dataSource = self
        self.tabBarController?.navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: "coinTableViewCell", bundle: nil), forCellReuseIdentifier: "coinCell")
        
        // MARK: - Completion Handler for Coin Info
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
            
            // MARK: - Completion Handler for Coin Info
            // Load all the coins from the API and Define in AllCoins
            self.coinAPI.getCoinAssetIcons() { [self] (CoinIcons) in
                
                // Create the url Map
                self.allIcons = CoinIcons
                for icon in self.allIcons {
                    self.urlMap[icon.assetID] = icon.url
                }
                
                for coin in popCoins {
                    let assetID = coin.assetID
                    let url = URL(string: urlMap[assetID] ?? "https://i.imgur.com/66HX61V.png")
//                    print(url ?? "")
                    let data = try? Data(contentsOf: url!)
                    
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        self.imageMap[assetID] = image
                    }
                    
                    
                    // Create the ImageMap
                    //let imageURL = URL(String: urlMap[icon.assetID]!)
                    /*
                     DispatchQueue.global().async {
                     guard let imageData = try? Data(contentsOf: imageURL) else { return }
                     image = UIImage(data: imageData ?? UIImage(named: "Logo"))
                     }*/
                    
                    
                    
                }
                /* Test print URL
                 print(popCoins[0])
                 print(urlMap[popCoins[0].assetID] ?? "www.google.com")*/
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - Tableview
extension mainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell", for: indexPath) as! coinTableViewCell
        let coinIcon: UIImage = imageMap[popCoins[indexPath.row].assetID] ?? UIImage(named: "Logo")!
        
        
        
        cell.coinName.text = popCoins[indexPath.row].name
        cell.coinSymbol.text = popCoins[indexPath.row].assetID
        cell.coinPrice.text = "$" + String(format: "%.3f", popCoins[indexPath.row].priceUsd ?? 0)
        cell.coinImage.image = coinIcon
        cell.configure()
        
        return cell
    }
}
