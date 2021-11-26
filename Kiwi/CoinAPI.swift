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
    
    func getCoinAssets(coins: [String]) -> CoinAssets {
        var coinList: CoinAssets = []
        var filteredCoins: String = ""
        for coin in coins {
            filteredCoins += coin
            filteredCoins += ","
        }
        
        let urlString = "\(baseURL)assets/?filter_asset_id=\(filteredCoins)&apikey=\(apiKey)"
        print(urlString)
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                else {
                    
                }
                
                if let safeData = data {
                    coinList = self.parseCoinAssetsJSON(safeData)
                    print(coinList)
                }
            }
            task.resume()
        }
        //print(coinList)
        return coinList
    }
    
    func getPopularCoins(numOfPopCoins: Int) -> CoinAssets{
        var sortedCoins: CoinAssets = self.getCoinAssets(coins: ["BTC", "ETH"])
        
        //sort the coinlist by the "volume_1day_usd" property
        sortedCoins = sortedCoins.sorted(by: { $0.volume1DayUsd > $1.volume1DayUsd })
        //print(sortedCoins)
        
        // Still need to figure out how to reduce the list of CoinAssets
        return sortedCoins
    }
    
    func parseCoinRateJSON(_ data: Data) -> Double  {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinRates.self, from: data)
            return decodedData.rate
            
        } catch {
            return -1
        }
    }
    
    func parseCoinAssetsJSON(_ data: Data)  -> CoinAssets{
        let decoder = JSONDecoder()
        do {
            let decodedData = try! decoder.decode(CoinAssets.self, from: data)
            return decodedData
            
          // Disabled error propagation with try!
//        } catch {
//            print("error")
//            return nil
        }
    }
}


