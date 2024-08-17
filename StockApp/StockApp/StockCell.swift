//
//  StockCell.swift
//  StockApp
//
//  Created by Kiarash Kiya on 2024-08-16.
//

import UIKit

class StockCell: UITableViewCell {
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    func configure(with stock: StockData) {
        tickerLabel.text = stock.ticker
        if let price = stock.lastPrice {
            priceLabel.text = "$\(price)"
        } else {
            priceLabel.text = "N/A"
        }
    }
}
