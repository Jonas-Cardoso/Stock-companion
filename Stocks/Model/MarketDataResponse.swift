//
//  MarketDataResponse.swift
//  Stocks
//
//  Created by jonas silva on 06/07/2021.
//

import Foundation

struct MarketDataResponse: Codable {
    let open: [Double]
    let close: [Double]
    let high: [Double]
    let low: [Double]
    let status: String
    let timeStamps: [TimeInterval]
    
    enum CodingKeys: String, CodingKey{
        case open = "o"
        case close = "c"
        case low = "l"
        case high = "h"
        case status = "s"
        case timeStamps = "t"
    }
    
    var candleSticks: [CandleStick] {
        var result = [CandleStick]()
        for index in 0..<open.count {
            result.append(.init(
                date: Date(timeIntervalSince1970: timeStamps[index]),
                high: high[index],
                low: low[index],
                open: open[index],
                close: close[index]))
        }
    
        let sortedData = result.sorted(by: { $0.date > $1.date })
        print(sortedData[0])
        return sortedData
    }
}

struct CandleStick {
    let date: Date
    let high: Double
    let low: Double
    let open: Double
    let close: Double
}
