//
//  CoinAPI.swift
//  CoinAPI
//
//  Created by student on 11/18/21.
//

import Foundation

struct CoinAPI {
    let baseURL = "https://rest.coinapi.io/v1/"
    let apiKey = "7D8FC0DB-38E3-4903-8CB4-098514B1C4B2"
    
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
        print(urlString)
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
}


