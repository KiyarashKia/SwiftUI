//
//  Purchase.swift
//  DessertOrder
//
//  Created by Kiarash Kiya on 2024-07-06.
//

import Foundation

// Class to represent a single purchase
class Purchase {
    var productName: String
    var quantity: Int
    var totalValue: Double
    var date: Date
    
    init(productName: String, quantity: Int, totalValue: Double, date: Date) {
        self.productName = productName
        self.quantity = quantity
        self.totalValue = totalValue
        self.date = date
    }
}
