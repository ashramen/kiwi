//
//  coinTableViewCell.swift
//  coinTableViewCell
//
//  Created by student on 11/21/21.
//

import UIKit

class coinTableViewCell: UITableViewCell {
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var coinView: UIView!
    @IBOutlet weak var coinPrice: UILabel!
    @IBOutlet weak var coinSymbol: UILabel!
    @IBOutlet weak var coinName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
        coinView.layer.shadowColor = UIColor.gray.cgColor
        coinView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        coinView.layer.shadowOpacity = 0.7
        coinView.layer.masksToBounds = false
        coinView.layer.cornerRadius = 8.0

    }
    
}
