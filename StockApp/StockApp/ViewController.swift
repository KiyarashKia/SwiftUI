//
//  ViewController.swift
//  StockApp
//
//  Created by Kiarash Kiya on 2024-08-16.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var activeStocks: [StockData] = []
    var watchingStocks: [StockData] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchResultCell")
        fetchDataFromAPI()
    }
    
    func fetchDataFromAPI() {
        let performanceIds = ["0P0000OQN8", "anotherValidPerformanceId", "yetAnotherValidPerformanceId"]

        for performanceId in performanceIds {
            NetworkManager.shared.fetchStockData(for: performanceId) { stockData in
                guard let stockData = stockData else {
                    print("Failed to fetch data for \(performanceId)")
                    return
                }

                DispatchQueue.main.async {
                    self.addStockToCorrectSection(stockData)
                }
            }
        }
    }
    
    func addStockToCorrectSection(_ stock: StockData) {
        let priceThreshold = 500.0
        
        // Safely unwrap lastPrice before comparing
        if let lastPrice = stock.lastPrice {
            if lastPrice > priceThreshold {
                activeStocks.append(stock)
            } else {
                watchingStocks.append(stock)
            }
        } else {
            print("Skipping stock with nil lastPrice")
        }
        
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "ACTIVE" : "WATCHING"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? activeStocks.count : watchingStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as! StockCell
        
        let stock = indexPath.section == 0 ? activeStocks[indexPath.row] : watchingStocks[indexPath.row]
        cell.configure(with: stock)
        
        return cell
    }
}
