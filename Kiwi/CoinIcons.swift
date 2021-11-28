//
//  CoinIcons.swift
//  Kiwi
//
//  Created by administrator on 11/28/21.
//

import Foundation

// MARK: - CoinIcons
struct CoinIcon: Codable {
    let assetID, url: String
    

    enum CodingKeys: String, CodingKey {
        case assetID = "asset_id"
        case url
    }
}

typealias CoinIcons = [CoinIcon]
