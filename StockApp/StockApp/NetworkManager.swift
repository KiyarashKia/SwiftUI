//
//  NetworkManager.swift
//  StockApp
//
//  Created by Kiarash Kiya on 2024-08-16.
//

import Foundation

class NetworkManager {

    static let shared = NetworkManager()

    private init() {}

    func fetchStockData(for performanceId: String, completion: @escaping (StockData?) -> Void) {
        guard let path = Bundle.main.path(forResource: "config", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path),
              let apiKey = config["API_KEY"] as? String,
              let apiHost = config["API_HOST"] as? String else {
            print("API keys not found in config.plist")
            completion(nil)
            return
        }

        let headers = [
            "x-rapidapi-key": apiKey,
            "x-rapidapi-host": apiHost
        ]
        
        guard let url = URL(string: "https://ms-finance.p.rapidapi.com/stock/v2/get-realtime-data?performanceId=\(performanceId)") else {
            print("Invalid URL")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(nil)
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("HTTP Error: \(httpResponse.statusCode)")
                completion(nil)
                return
            }

            if let data = data {
                do {
                    let stockData = try JSONDecoder().decode(StockData.self, from: data)
                    completion(stockData)
                } catch {
                    print("Error decoding data: \(error)")
                    completion(nil)
                }
            }
        }

        dataTask.resume()
    }
}
