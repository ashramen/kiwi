//
//  CoinAPI.swift
//  CoinAPI
//
//  Created by student on 11/18/21.
//

import Foundation

struct CoinAPI {
    let baseURL = "https://rest.coinapi.io/v1/"
    let apiKey = "9FE3C84A-D2D6-4BB4-AD20-0E230B76799A"
    
    /*Old API Keys
      "9FE3C84A-D2D6-4BB4-AD20-0E230B76799A"
    //"B31F0065-E3B2-488E-958D-48D85F9EF566"*/
     
     /* New API Keys
      "76642117-ABBF-4C53-BFD4-992A337244B8"
      "0128B164-04A9-4E70-A11B-3F03587FB62E"
      "6C716B71-ACAE-4C27-AE7F-C30214713D1F"
      "9EA6DEE8-F757-4D94-B53F-BB070F8CF92C"
      "1F6B4880-EF06-44B7-B798-29B568F34A84"
    */
    
    func getCoinPrice(coin: String, currency: String) -> String {
        let urlString = "\(baseURL)exchangerate/\(coin)/\(currency)/?apikey=\(apiKey)"
        var coinPriceStr: String = ""
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let coinPrice = self.parseCoinRateJSON(safeData)
                    coinPriceStr = String(format: "%.2f", coinPrice)
                    print(coinPriceStr)
                }
            }
            task.resume()
        }
        return coinPriceStr
    }
    
    // MARK: - GetCoinAssets()
    // Returns all Coins from API call as a list of CoinAsset (sorted by volume1DayUsd)
    func getCoinAssets(completionHandler: @escaping (CoinAssets) -> Void) {
        let coins: [String] = []
        var allCoins: CoinAssets = []
        var filteredCoins: String = ""
        for coin in coins {
            filteredCoins += coin
            filteredCoins += ","
        }
        
        let urlString = "\(baseURL)assets/?filter_asset_id=\(filteredCoins)&apikey=\(apiKey)"
        print("getCoinAssets(): \t", urlString, "\n")
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    allCoins = self.parseCoinAssetsJSON(safeData)
                    allCoins = allCoins.sorted(by: { $0.volume1DayUsd > $1.volume1DayUsd })
                    completionHandler(allCoins)
                }
            })
            task.resume()
        }
        
    }
    
    // MARK: - GetCoinAssetIcons()
    func getCoinAssetIcons(completionHandler: @escaping (CoinIcons) -> Void) {
        var allCoinIcons: CoinIcons = []
        let dimensions: String = "32"
        let urlString = "\(baseURL)assets/icons/\(dimensions)/?apikey=\(apiKey)"
        print("getCoinAssetIcons(): \t", urlString, "\n")
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    allCoinIcons = self.parseCoinIconsJSON(safeData)
                    //print(allCoinIcons[0])
                    completionHandler(allCoinIcons)
                }
            })
            task.resume()
        }
    }
    
    // MARK: - ParseCoinRateJSON
    func parseCoinRateJSON(_ data: Data) -> Double  {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinRates.self, from: data)
            return decodedData.rate
            
        } catch {
            return -1
        }
    }
    
    // MARK: - ParseCoinAssetsJSON
    func parseCoinAssetsJSON(_ data: Data) -> CoinAssets {
        let decoder = JSONDecoder()
        do {
            let decodedData = try! decoder.decode(CoinAssets.self, from: data)
            //print(decodedData)
            return decodedData
        }
    }
    
    // MARK: - ParseCoinIconsJSON
    func parseCoinIconsJSON(_ data: Data) -> CoinIcons {
        let decoder = JSONDecoder()
        do {
            let decodedData = try! decoder.decode(CoinIcons.self, from: data)
            //print(decodedData)
            return decodedData
        }
    }
}


