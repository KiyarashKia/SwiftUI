//
//  SearchViewController.swift
//  StockApp
//
//  Created by Kiarash Kiya on 2024-08-16.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var searchResults: [StockData] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            performSearch(query: searchText)
        } else {
            searchResults.removeAll()
            tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        let stock = searchResults[indexPath.row]
        cell.textLabel?.text = stock.ticker
        cell.detailTextLabel?.text = "$\(String(describing: stock.lastPrice))"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = searchResults[indexPath.row]
        // Handle the selection of a stock, possibly by adding it to a watch list or showing more details
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func performSearch(query: String) {
        guard let path = Bundle.main.path(forResource: "config", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path),
              let apiKey = config["API_KEY"] as? String,
              let apiHost = config["API_HOST"] as? String else {
            print("API keys not found in config.plist")
            return
        }

        let headers = [
            "x-rapidapi-key": apiKey,
            "x-rapidapi-host": apiHost
        ]
        
        guard let url = URL(string: "https://ms-finance.p.rapidapi.com/stock/v2/get-summary?symbol=\(query)&region=US") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }

            if let data = data {
                do {
                    let stockData = try JSONDecoder().decode(StockData.self, from: data)
                    DispatchQueue.main.async {
                        self.searchResults = [stockData]
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error decoding data: \(error)")
                    print("Raw JSON: \(String(data: data, encoding: .utf8) ?? "No data")")
                }
            }
        }

        dataTask.resume()
    }
}
