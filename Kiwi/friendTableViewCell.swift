//
//  friendTableViewCell.swift
//  friendTableViewCell
//
//  Created by student on 11/28/21.
//

import UIKit

class friendTableViewCell: UITableViewCell {
    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var friendEmail: UILabel!
    @IBOutlet weak var friendCoins: UILabel!
    
    
    func configure() {
        friendView.layer.shadowColor = UIColor.gray.cgColor
        friendView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        friendView.layer.shadowOpacity = 1.0
        friendView.layer.masksToBounds = false
        friendView.layer.cornerRadius = 10.0

    }
}
