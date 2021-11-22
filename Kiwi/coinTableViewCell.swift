//
//  coinTableViewCell.swift
//  coinTableViewCell
//
//  Created by student on 11/21/21.
//

import UIKit

class coinTableViewCell: UITableViewCell {
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coinSymbol: UILabel!
    @IBOutlet weak var coinPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
