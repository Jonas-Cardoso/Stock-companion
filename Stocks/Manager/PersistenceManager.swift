//
//  PersistenceManager.swift
//  Stocks
//
//  Created by jonas silva on 02/07/2021.
//

import Foundation

// we´ll save symbols, for each symbol a dictionary to the long form name

final class PersistenceManager {
    static let shared = PersistenceManager()
    
    private let userDefaults: UserDefaults = .standard
    
    private struct Constants {
        static let onBoardedKey = "hasOnboarded"
        static let watchListKey = "watchlist"
        
    }
    private init() {}
    
    //MARK: - PUBLIC
    
    public var watchlist:[String]{
        if !hasOnBoarded {
            userDefaults.set(true, forKey: Constants.onBoardedKey)
            setUpDefaults()
        }
        return userDefaults.stringArray(forKey: Constants.watchListKey) ?? []
    }
    
    public func watchListContains(symbol: String) -> Bool {
        return watchlist.contains(symbol) 
    }
    
    public func addToWatchList(symbol: String, companyName: String){
        var current = watchlist
        current.append(symbol.uppercased())
        userDefaults.set(current, forKey: Constants.watchListKey)
        userDefaults.set(companyName, forKey: symbol)
        
        NotificationCenter.default.post(name: .didAddtoWatchList, object: nil)
    }
    public func removeFromWatchList(symbol: String){
        var newList = [String]()
        print("Deleting: \(symbol)")
        userDefaults.set(nil,forKey: symbol)
        for item in watchlist where item != symbol {
            print("\n\n\n\(item)")
            newList.append(item)
        }
        userDefaults.set(newList,forKey: Constants.watchListKey)
    }
    
    //MARK: - PRIVATE
    private var hasOnBoarded: Bool {
        return userDefaults.bool(forKey: Constants.onBoardedKey)
    }
    private func setUpDefaults() {
        
        let map: [String:String] = [
            "AAPL":"Apple Inc.",
            "MSFT":"Microsoft Corporation",
            "SNAP":"Snap Inc.",
            "GOOG":"Alphabet",
            "AMZN":"Amazon.com, Inc.",
            "WORK":"Slack Technologies",
            "FB":"Facebook Inc.",
            "NVDA":"Nvidia Inc.",
            "NKE":"Nike",
            "PINS":"Pinterest Inc."
        ]
        
        let symbols = map.keys.map{ $0 }
        userDefaults.set(symbols, forKey: Constants.watchListKey)
        
        for (symbol, name) in map {
            userDefaults.set(name, forKey: symbol)
        }
        
    }
}
