//
//  friendsViewController.swift
//  friendsViewController
//
//  Created by student on 11/21/21.
//

import UIKit

class friendsViewController: UIViewController {
    
    @IBOutlet weak var cardTableView: UITableView!
    
    var friends: [Friend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Friends"
        self.tabBarController?.navigationItem.hidesBackButton = true
        cardTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension friendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cardTableView.dequeueReusableCell(withIdentifier: "friendCellIdentifier") as! friendTableViewCell
        cell.friendEmail.text = "ash@gmail.com"
        cell.friendCoins.text = "ETH, BTC"
        return cell
    }
    
    
}
