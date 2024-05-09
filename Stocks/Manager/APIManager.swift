//
//  APIManager.swift
//  Stocks
//
//  Created by jonas silva on 02/07/2021.
//

import UIKit

// singleton
final class APIManager {
    static let shared = APIManager()
    
    private struct Constants {
        static let apiKey = "c3gud6aad3i83du7jev0"
        static let sandboxApiKey = "sandbox_c3gud6aad3i83du7jevg"
        static let baseUrl = "https://finnhub.io/api/v1/"
        static let day: TimeInterval =  3600 * 24
    }
    
    private init(){}
    
    // MARK: - Public
    
    public func search(
        query: String,
        completion: @escaping(Result<SearchResponse,Error>) -> Void
    ) {
        guard let safeQuery = query.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed)
        else {
            return
        }
        request(
            url: url(
                for: .search,
                queryParams: ["q":safeQuery]),
            expecting: SearchResponse.self, completion: completion)
    }
    
    public func news(for type: NewsViewController.`Type`, completion: @escaping(Result<[NewsStory],Error>)->Void){
       
        switch type {
        case .topStories:
            request(url: url(for: .topStories, queryParams: ["category" : "general"]),
                    expecting: [NewsStory].self,
                    completion: completion)
        case .company(symbol: let symbol):
            let today = Date()
            let oneMonthBack = today.addingTimeInterval(-(Constants.day*7))
            request(url: url(for: .companyNews, queryParams: [
                "symbol" : symbol,
                "from" : DateFormatter.newsDateFormatter.string(from: oneMonthBack),
                "to" : DateFormatter.newsDateFormatter.string(from: today)
                ]),
                expecting: [NewsStory].self,
                completion: completion)
        }
    }
    
    
    public func marketData(
        for symbol: String,
        numberOfDays: TimeInterval = 7,
        completion: @escaping (Result<MarketDataResponse,Error>) -> Void
    ) {
        let today = Date().addingTimeInterval(-(Constants.day))
        let prior = today.addingTimeInterval(-(Constants.day * numberOfDays))
        
        request(
            url:url(for: .marketData,
                    queryParams: [
                        "symbol": symbol,
                        "resolution": "1",
                        "from": "\(Int(prior.timeIntervalSince1970))",
                        "to": "\(Int(today.timeIntervalSince1970))"
                    ]),
            expecting: MarketDataResponse.self,
            completion: completion
        )
        
    }
    
    public func financialMetrics(for symbol: String, completion: @escaping(Result<financialMetricsResponse,Error>) -> Void) {
        let url = url(for: .financials, queryParams: ["symbol": symbol, "metric": "all"])
        request(url: url, expecting: financialMetricsResponse.self, completion: completion)
    }
    
    // MARK: - Private
    
    private enum Endpoint: String {
        case search = "search"
        case topStories = "news"
        case companyNews = "company-news"
        case marketData = "stock/candle"
        case financials = "stock/metric"
    }
    
    private enum APIError: Error {
        case noDataReturned
        case invalidUrl
    }
    
    private func url(
        for endpoint: Endpoint,
        queryParams: [String:String] = [:])
        -> URL? {
            var urlString = Constants.baseUrl + endpoint.rawValue
            var queryItems = [URLQueryItem]()
            // add any parameters
            for (key, value) in queryParams {
                queryItems.append(.init(name: key, value: value))
            }
            
            // add token
            queryItems.append(.init(name: "token", value: Constants.apiKey))
            
            //convert query items to suffix string
            urlString += "?" + queryItems.map {"\($0.name)=\($0.value ?? "")"}.joined(separator: "&")
            
            return URL(string: urlString)
            
        }
    
    private func request<T: Codable>(
        url: URL?,
        expecting: T.Type,
        completion: @escaping (Result<T,Error>)-> Void
    ){
        guard let url = url else {
            completion(.failure(APIError.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(APIError.noDataReturned))
                }
                return
            }
            
            do{
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
