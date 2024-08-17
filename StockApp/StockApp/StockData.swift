//
//  StockData.swift
//  StockApp
//
//  Created by Kiarash Kiya on 2024-08-16.
//

import Foundation

struct StockData: Decodable {
    let ticker: String?
    let lastPrice: Double?
    var rank: String?
    
    enum CodingKeys: String, CodingKey {
        case ticker
        case lastPrice
    }
}
