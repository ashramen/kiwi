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
    
    let cellIdentifier = "coinIdentifier"
    var coins: [Coin] = [
        Coin(name: "BTC", rate: "57384.21"),
        Coin(name: "ETH", rate: "4856.7"),
        Coin(name: "ETC", rate: "57.8")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        navigationItem.hidesBackButton = true
        
        // Do any additional setup after loading the view.
    }
    
    let coinAPI = CoinAPI()
    @IBAction func searchBtn(_ sender: UIButton) {
        let coinPrice = coinAPI.getCoinPrice(coin: coinSearchText.text ?? "BTC", currency: "USD")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
