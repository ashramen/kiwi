import Foundation

// MARK: - CoinRate
struct CoinRates: Codable {
    let time, assetIDBase, assetIDQuote: String
    let rate: Double
    let srcSideBase: [SrcSideBase]

    enum CodingKeys: String, CodingKey {
        case time
        case assetIDBase = "asset_id_base"
        case assetIDQuote = "asset_id_quote"
        case rate
        case srcSideBase = "src_side_base"
    }
}

// MARK: - SrcSideBase
struct SrcSideBase: Codable {
    let time, asset: String
    let rate, volume: Double
}
